/* ====================
Outputs
==================== */

output "layer_arn" {
  value       = aws_lambda_layer_version.layer.arn
}

/* ====================
Resources
==================== */

data "archive_file" "layer_pkg" {
  type        = "zip"
  source_dir  = "${path.module}/src/${var.layer_name}"
  output_path = "${path.module}/src/${var.layer_name}.zip"
}

resource "aws_lambda_layer_version" "layer" {
  filename            = data.archive_file.layer_pkg.output_path
  source_code_hash    = data.archive_file.layer_pkg.output_base64sha256
  layer_name          = var.layer_name
  compatible_runtimes = ["python3.7"]
}

