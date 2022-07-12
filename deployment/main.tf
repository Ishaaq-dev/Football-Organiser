locals {
  contacts_dynamo_name = "${var.prefix}-${var.project}-contacts"
}

module "handle_incoming_responses_lambda_function" {
  source = "./modules/lambda"

  prefix      = var.prefix
  project     = var.project
  function_name = "handle-incoming-responses"
  layer_arns  = [aws_lambda_layer_version.util_layer.arn]
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
}

module "contact_players_lambda_function" {
  source = "./modules/lambda"

  prefix      = var.prefix
  project     = var.project
  function_name = "contact-players"
  layer_arns  = [aws_lambda_layer_version.util_layer.arn]
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
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
  function_arn = module.handle_incoming_responses_lambda_function.function_arn
}

module "weekly_monday_cw_rule" {
  source = "./modules/cw-events"

  cw_event_rule_name = "weekly_monday"
  cw_event_rule_description = "A rule to fire events weekly on Monday at 10:00"
  cron = "cron(0 10 ? * MON *)"

  function_name = module.contact_players_lambda_function.function_name
  function_arn = module.contact_players_lambda_function.function_arn
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
