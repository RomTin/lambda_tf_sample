/* ====================
Output
==================== */

output "sqs_name" {
  value = aws_sqs_queue.function_queue.name
}

output "dlq_name" {
  value = aws_sqs_queue.function_dlq.name
}

/* ====================
SQS
==================== */

resource "aws_sqs_queue" "function_queue" {
  name                       = "${var.function_name}-queue"
  visibility_timeout_seconds = 60
  redrive_policy             = <<JSON
{
    "deadLetterTargetArn": "${aws_sqs_queue.function_dlq.arn}",
    "maxReceiveCount": 20
}
JSON

  depends_on = [aws_sqs_queue.function_dlq]

}

resource "aws_sqs_queue" "function_dlq" {
  name                       = "${var.function_name}-dlq"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 1209600
}

resource "aws_sqs_queue_policy" "function_queue_policy" {
  queue_url = aws_sqs_queue.function_queue.id
  policy    = data.aws_iam_policy_document.function_queue_policy_document.json
}

data "aws_iam_policy_document" "function_queue_policy_document" {
  version = "2012-10-17"

  statement {
    sid       = "${var.function_name}SNSToSQS"
    actions   = ["sqs:SendMessage"]
    effect    = "Allow"
    resources = [aws_sqs_queue.function_queue.arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.trigger.arn]
    }
  }
}

resource "aws_lambda_event_source_mapping" "function_trigger" {
  event_source_arn = aws_sqs_queue.function_queue.arn
  function_name    = aws_lambda_function.function.arn
  enabled          = true
  batch_size       = 1
}

resource "aws_lambda_event_source_mapping" "function_dlq_trigger" {
  event_source_arn = aws_sqs_queue.function_dlq.arn
  function_name    = var.dlq_handler_arn
  enabled          = true
  batch_size       = 1
}
