locals {
  contacts_dynamo_name = "${var.prefix}-${var.project}-contacts"
}

module "handle_incoming_responses_lambda_function" {
  source = "./modules/lambda"

  prefix      = var.prefix
  project     = var.project
  lambda_name = "handle-incoming-responses"
  layer_arns  = [aws_lambda_layer_version.util_layer.arn]
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
}

module "contact_players_lambda_function" {
  source = "./modules/lambda"

  prefix      = var.prefix
  project     = var.project
  lambda_name = "contact-players"
  layer_arns  = [aws_lambda_layer_version.util_layer.arn]
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.contact_players_lambda_function.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_cw_rule.arn
}

data "archive_file" "archive_util_layers" {
  type        = "zip"
  source_dir  = "${path.module}/../src/utils"
  output_path = "${path.module}/src-zip/utils.zip"
}

resource "aws_lambda_layer_version" "util_layer" {
  filename         = "src-zip/utils.zip"
  layer_name       = "utils"
  source_code_hash = filebase64sha256("src-zip/utils.zip")

  compatible_runtimes = ["python3.9"]
}

module "incoming_sns_sqs" {
  source = "./modules/sns-sqs"

  prefix     = var.prefix
  project    = var.project
  name       = "enquire-incoming-sms"
  lambda_arn = module.handle_incoming_responses_lambda_function.lambda_arn
}

resource "aws_cloudwatch_event_rule" "weekly_cw_rule" {
  name = "weekly_monday"
  description = "A rule to fire events weekly on Monday"
  schedule_expression = "cron(0 10 ? * MON *)"
}

resource "aws_cloudwatch_event_target" "cw_rule_contact_players" {
  arn  = module.contact_players_lambda_function.lambda_arn
  rule = aws_cloudwatch_event_rule.weekly_cw_rule.id

}

resource "aws_dynamodb_table" "contacts_dynamodb" {
  name           = local.contacts_dynamo_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "phone_number"

  attribute {
    name = "phone_number"
    type = "S"
  }
}
