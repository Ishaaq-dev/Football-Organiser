locals {
  prefix = "${var.prefix}-${var.project}-"
}

resource "aws_sns_topic" "sns_topic" {
  name = "${local.prefix}-${var.name}-sns"
}

resource "aws_sqs_queue" "sqs_queue" {
  name = "${local.prefix}-${var.name}-sqs"
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.sqs_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "sns_sqs_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn
}

resource "aws_lambda_event_source_mapping" "sqs_function_mapping" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name    = var.lambda_arn
}
