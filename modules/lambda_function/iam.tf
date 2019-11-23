/* ====================
IAM Role
==================== */
resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.function_name}-role"
  path               = "/"
  description        = "IAM Role for Lambda function / ${var.function_name} (Managed by Terraform)"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy_document.json
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "lambda-${var.function_name}-role-policy"
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.lambda_role_policy_document.json
}

data "aws_iam_policy_document" "lambda_assume_policy_document" {
  version = "2012-10-17"

  statement {
    sid     = "${var.function_name}RoleLambda"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_role_policy_document" {
  version = "2012-10-17"

  statement {
    sid       = "${var.function_name}RoleLambdaCWLogs"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["logs:*"]
  }
}
