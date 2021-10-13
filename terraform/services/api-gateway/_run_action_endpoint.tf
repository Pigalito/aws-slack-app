resource "aws_api_gateway_resource" "run_action" {
  parent_id   = aws_api_gateway_rest_api.slack_commands.root_resource_id
  path_part   = "action"
  rest_api_id = aws_api_gateway_rest_api.slack_commands.id
}

resource "aws_api_gateway_method" "run_action" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.run_action.id
  rest_api_id   = aws_api_gateway_rest_api.slack_commands.id
}

resource "aws_api_gateway_integration" "run_action" {
  http_method             = aws_api_gateway_method.run_action.http_method
  resource_id             = aws_api_gateway_resource.run_action.id
  rest_api_id             = aws_api_gateway_rest_api.slack_commands.id
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.handle_slack_request_lambda_invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.handle_slack_request_lambda_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:us-east-2:${var.aws_account_id}:${aws_api_gateway_rest_api.slack_commands.id}/*/${aws_api_gateway_method.run_action.http_method}${aws_api_gateway_resource.run_action.path}"
}