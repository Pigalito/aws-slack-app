resource "aws_api_gateway_rest_api" "slack_commands" {
  name = "slack-commands"
}

resource "aws_api_gateway_deployment" "slack_commands" {
  rest_api_id = aws_api_gateway_rest_api.slack_commands.id

  depends_on = [
    aws_api_gateway_integration.run_action,
    aws_api_gateway_resource.run_action,
    aws_api_gateway_method.run_action,
  ]

  triggers = {
    redeployment = sha1(timestamp())
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "staging" {
  depends_on = [aws_cloudwatch_log_group.slack_commands]

  deployment_id = aws_api_gateway_deployment.slack_commands.id
  rest_api_id   = aws_api_gateway_rest_api.slack_commands.id
  stage_name    = "staging"
}

resource "aws_cloudwatch_log_group" "slack_commands" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.slack_commands.id}/staging"
  retention_in_days = 7
}

resource "aws_api_gateway_method_settings" "slack_commands" {
  rest_api_id = aws_api_gateway_rest_api.slack_commands.id
  stage_name  = aws_api_gateway_stage.staging.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "ERROR"
  }
}