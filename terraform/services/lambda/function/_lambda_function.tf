resource "aws_lambda_function" "lambda" {
  s3_bucket     = var.deployment_bucket
  s3_key        = "lambdas/${var.name}-${var.lambda_version}.zip"
  function_name = var.name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime

  dynamic "environment" {
    for_each = local.environment_variables
    content {
      variables = environment.value
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  for_each   = local.iam_policy_attachments
  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 14
}

resource "aws_lambda_event_source_mapping" "sqs" {
  count            = "${var.include_sqs == true ? 1 : 0}"
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.lambda.arn
  batch_size       = var.sqs_batch_size
}

