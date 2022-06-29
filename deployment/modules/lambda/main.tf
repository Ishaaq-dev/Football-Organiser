locals {
    lambda_file_name = "src-zip/${var.lambda_name}.zip"
    function_name = "${var.prefix}-${var.project}-${var.lambda_name}"
}

data "archive_file" "archive_lambda_src" {
  type        = "zip"
  source_dir  = "${path.module}/../../../src/lambda/${var.lambda_name}"
  output_path = "${path.module}/../../src-zip/${var.lambda_name}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename = local.lambda_file_name
  function_name = local.function_name
  role = var.role_arn
  handler = var.lambda_handler 
  source_code_hash = filebase64sha256(local.lambda_file_name)
  runtime = var.lambda_runtime
  layers = var.layer_arns

  environment {
    variables = var.env_vars
  }
}
