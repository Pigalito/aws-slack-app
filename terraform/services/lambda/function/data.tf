data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}