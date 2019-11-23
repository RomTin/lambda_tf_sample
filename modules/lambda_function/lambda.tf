/* ====================
Lambda function
==================== */

data "template_file" "function" {
  template = file("${path.module}/src/${var.function_name}.py")
}

data "archive_file" "function_pkg" {
  type        = "zip"
  output_path = "${path.module}/src/${var.function_name}.zip"

  source {
    content  = data.template_file.function.rendered
    filename = "main.py"
  }
}

resource "aws_lambda_function" "function" {
  runtime                        = "python3.7"
  filename                       = data.archive_file.function_pkg.output_path
  source_code_hash               = data.archive_file.function_pkg.output_base64sha256
  function_name                  = var.function_name
  layers                         = var.lambda_layer_arns
  handler                        = "main.handle"
  timeout                        = var.timeout
  memory_size                    = var.memory
  reserved_concurrent_executions = var.concurrent_limitation
  description                    = "Lambda function / ${var.function_name} (Managed by Terraform)"
  role                           = aws_iam_role.lambda_role.arn
}
