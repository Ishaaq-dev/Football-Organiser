resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.cw_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "cw_event_rule" {
  name                = var.cw_event_rule_name
  description         = var.cw_event_rule_description
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "cw_event_target" {
  arn  = var.function_arn
  rule = aws_cloudwatch_event_rule.cw_event_rule.id
#   need to add cloudwatch event rule input object to variables.tf file
}
