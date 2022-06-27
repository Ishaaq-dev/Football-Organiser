# need to create the following:
# - Lambda
# - sns
# - sqs
# - pinpoint
# - storage (DynamoDB/ElasticSearch)

locals {
  lambda_handler               = "LambdaHandler.process_event"
  contacts_dynamo_name         = "${var.prefix}-${var.project}-contacts"

  # Incoming Lambda
  enquire_incoming_sns_name    = "${var.prefix}-${var.project}-enquire-incoming-sms-sns"
  enquire_incoming_message_sqs = "${var.prefix}-${var.project}-enquire-incoming-sms-sqs"
}

module "incoming_lambda_function" {
  source = "./modules/lambda"
  prefix = var.prefix
  project = var.project
  lambda_name = "incoming-lambda"
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
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
  function_name    = module.incoming_lambda_function.lambda_arn
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
