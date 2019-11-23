/* ====================
IAM Role
==================== */
resource "aws_iam_role" "lambda_role" {
  name               = "lambda-dlq-role"
  path               = "/"
  description        = "IAM Role for Lambda function / dlq (Managed by Terraform)"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy_document.json
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "lambda-dlq-role-policy"
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.lambda_role_policy_document.json
}

data "aws_iam_policy_document" "lambda_assume_policy_document" {
  version = "2012-10-17"

  statement {
    sid     = "DlqRoleLambda"
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
    sid       = "DlqRoleLambdaCWLogs"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["logs:*"]
  }

  statement {
    sid       = "DlqRoleLambdaSQS"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
  }

  statement {
    sid       = "DlqRoleLambdaS3"
    effect    = "Allow"
    resources = [aws_s3_bucket.dlq_storage.arn, "${aws_s3_bucket.dlq_storage.arn}/*"]
    actions   = ["s3:ListBucket", "s3:*Object"]
  }
}
