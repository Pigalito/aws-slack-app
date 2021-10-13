locals {
  environment_variables  = var.env_vars == null ? [] : [var.env_vars]
  iam_policy_attachments = toset(var.iam_policies)
}