terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15"
    }
  }
}

terraform {
  backend "remote" {
    organization = "HackettIncorporated"

    workspaces {
      name = "aws-slack-app"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

module "lambda" {
  source            = "./services/lambda"
  deployment_bucket = var.deployment_bucket
}

module "api_gateway" {
  source                                 = "./services/api-gateway"
  handle_slack_request_lambda_invoke_arn = module.lambda.handle_slack_request_lambda_invoke_arn
  handle_slack_request_lambda_name       = module.lambda.handle_slack_request_lambda_name
  aws_account_id                         = data.aws_caller_identity.current.account_id
}