// Required variables for all lambdas

variable "name" {
  type = string
}
variable "deployment_bucket" {
  type = string
}

// Optional variables for all lambdas
variable "env_vars" {
  type    = map(any)
  default = null
}
variable "lambda_version" {
  type    = string
  default = "1.0.0"
}

variable "runtime" {
  type    = string
  default = "nodejs14.x"
}

variable "handler" {
  type    = string
  default = "index.handler"
}

variable "iam_policies" {
  type    = list(string)
  default = []
}

// Variables that must be overridden for lambdas triggered by SQS
variable "include_sqs" {
  type    = bool
  default = false
}

variable "sqs_queue_arn" {
  type    = string
  default = ""
}

variable "sqs_batch_size" {
  type    = number
  default = 1
}