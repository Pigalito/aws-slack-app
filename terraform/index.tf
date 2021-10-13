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
