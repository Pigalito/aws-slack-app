module "handle_slack_request_lambda" {
  source            = "./function"
  name              = "handle-slack-request"
  lambda_version    = "0.1.3"
  deployment_bucket = var.deployment_bucket
}