locals {
    lambda_file_name = "src-zip/${var.function_name}.zip"
    function_name = "${var.prefix}-${var.project}-${var.function_name}"
}

data "archive_file" "archive_lambda_src" {
  type        = "zip"
  source_dir  = "${path.module}/../../../src/lambda/${var.function_name}"
  output_path = "${path.module}/../../src-zip/${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename = local.lambda_file_name
  function_name = local.function_name
  role = var.role_arn
  handler = var.lambda_handler 
  source_code_hash = filebase64sha256(local.lambda_file_name)
  runtime = var.lambda_runtime
  layers = var.layer_arns

  vpc_config {
    subnet_ids = [ "subnet-65a4393f", "subnet-57eaba31", "subnet-e4edceac" ]
    security_group_ids = [ "sg-0e55969d4207c67b1", "sg-4c8c2c07" ]
  }

  environment {
    variables = var.env_vars
  }
}
