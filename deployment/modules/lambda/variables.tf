variable "prefix" {
  type = string
}

variable "project" {
  type = string
}

variable "function_name" {
  type = string
}

variable "role_arn" {
  type = string
  default = "arn:aws:iam::574674178402:role/iam_for_lambda"
}

variable "lambda_handler" {
  type = string
  default = "LambdaHandler.process_event"
}

variable "lambda_runtime" {
  type = string
  default = "python3.9"
}

variable "env_vars" {
  type = map
}

variable "layer_arns" {
  type = list
}