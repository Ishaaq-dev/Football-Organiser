# need to create the following:
# - Lambda - done
# - sns - done
# - sqs - done
# - pinpoint - create resource then import remote config
# - storage (DynamoDB/ElasticSearch) - done

locals {
  contacts_dynamo_name         = "${var.prefix}-${var.project}-contacts"
}

module "incoming_lambda_function" {
  source = "./modules/lambda"

  prefix = var.prefix
  project = var.project
  lambda_name = "incoming-lambda"
  layer_arns = [aws_lambda_layer_version.util_layer.arn]
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
}

module "contact_players_lambda_function" {
  source = "./modules/lambda"

  prefix = var.prefix
  project = var.project
  lambda_name = "contact-players"
  layer_arns = [aws_lambda_layer_version.util_layer.arn]
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
}

data "archive_file" "archive_util_layers" {
  type = "zip"
  source_dir = "${path.module}/../src/utils"
  output_path = "${path.module}/src-zip/utils.zip"
}

resource "aws_lambda_layer_version" "util_layer" {
  filename   = "src-zip/utils.zip"
  layer_name = "utils"
  source_code_hash = filebase64sha256("src-zip/utils.zip")

  compatible_runtimes = ["python3.9"]
}

module "incoming_sns_sqs" {
  source = "./modules/sns-sqs"

  prefix = var.prefix
  project = var.project
  name = "enquire-incoming-sms"
  lambda_arn = module.incoming_lambda_function.lambda_arn
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
