# need to create the following:
# - Lambda
# - sns
# - sqs
# - pinpoint
# - storage (DynamoDB/ElasticSearch)

locals {
  incoming_lambda_name      = "${var.prefix}-${var.project}-handle-incoming-sms"
  incoming_lambda_file_name = "src-zip/incoming-lambda.zip"
  lambda_handler            = "LambdaHandler.process_event"

  contacts_dynamo_name = "${var.prefix}-${var.project}-contacts"

  enquire_incoming_sns_name = "${var.prefix}-${var.project}-enquire-incoming-sms-sns"

  enquire_incoming_message_sqs = "${var.prefix}-${var.project}-enquire-incoming-sms-sqs"
}

data "archive_file" "incoming_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/lambda/incoming-lambda"
  output_path = "${path.module}/src-zip/incoming-lambda.zip"
}

resource "aws_lambda_function" "incoming_lambda" {
  filename         = local.incoming_lambda_file_name
  function_name    = local.incoming_lambda_name
  role             = "arn:aws:iam::574674178402:role/iam_for_lambda"
  handler          = local.lambda_handler
  source_code_hash = filebase64sha256(local.incoming_lambda_file_name)
  runtime          = "python3.9"

  environment {
    variables = {
      contacts_table = aws_dynamodb_table.contacts_dynamodb.name
    }
  }
}

resource "aws_sns_topic" "enquire_incoming_message_sns" {
  name = local.enquire_incoming_sns_name
}

resource "aws_sqs_queue" "enquire_incoming_message_sqs" {
  name = local.enquire_incoming_message_sqs
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.enquire_incoming_message_sqs.id

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
      "Resource": "${aws_sqs_queue.enquire_incoming_message_sqs.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.enquire_incoming_message_sns.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "enquire_incoming_sns_sqs_subscription" {
  topic_arn = aws_sns_topic.enquire_incoming_message_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.enquire_incoming_message_sqs.arn
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.enquire_incoming_message_sqs.arn
  function_name    = aws_lambda_function.incoming_lambda.arn
}

resource "aws_dynamodb_table" "contacts_dynamodb" {
  name           = local.contacts_dynamo_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
