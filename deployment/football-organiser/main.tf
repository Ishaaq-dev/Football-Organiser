# need to create the following:
# - Lambda
# - sns
# - sqs
# - pinpoint
# - storage (DynamoDB/ElasticSearch)

locals {
  incoming_lambda_name = "${var.environment}-${var.project}-handle-incoming-sms"
}

data "archive_file" "incoming_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/lambda/incoming-lambda"
  output_path = "${path.module}/src-zip/incoming-lambda.zip"
}

resource "aws_lambda_function" "incoming_lambda" {
  filename         = "src-zip/incoming-lambda.zip"
  function_name    = local.incoming_lambda_name
  role             = "arn:aws:iam::574674178402:role/iam_for_lambda"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("src-zip/incoming-lambda.zip")
  runtime          = "python3.9"
}
