/* ====================
S3
==================== */

resource "aws_s3_bucket" "dlq_storage" {
  bucket = "dlq-storage"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "dlq_storage" {
  bucket                  = aws_s3_bucket.dlq_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.dlq_storage]
}
