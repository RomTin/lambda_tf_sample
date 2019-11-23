/* ====================
Outputs
==================== */

output "function_arn" {
  value = aws_lambda_function.function.arn
}

/* ====================
Lambda function
==================== */

data "template_file" "function" {
  template = file("${path.module}/src/dlq.py")
  vars = {
    bucket_name = aws_s3_bucket.dlq_storage.bucket
  }
}

data "archive_file" "function_pkg" {
  type        = "zip"
  output_path = "${path.module}/src/dlq.zip"

  source {
    content  = data.template_file.function.rendered
    filename = "main.py"
  }
}

resource "aws_lambda_function" "function" {
  runtime                        = "python3.7"
  filename                       = data.archive_file.function_pkg.output_path
  source_code_hash               = data.archive_file.function_pkg.output_base64sha256
  function_name                  = "dlq"
  handler                        = "main.handle"
  timeout                        = var.timeout
  memory_size                    = var.memory
  reserved_concurrent_executions = var.concurrent_limitation
  description                    = "Lambda function / dlq (Managed by Terraform)"
  role                           = aws_iam_role.lambda_role.arn
}
