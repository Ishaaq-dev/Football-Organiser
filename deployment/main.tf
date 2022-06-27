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
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
}

module "contact_players_lambda_function" {
  source = "./modules/lambda"

  prefix = var.prefix
  project = var.project
  lambda_name = "contact-players"
  env_vars = {
    contacts_table = aws_dynamodb_table.contacts_dynamodb.name
  }
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
