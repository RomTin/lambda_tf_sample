/* ====================
SNS
==================== */

resource "aws_sns_topic" "trigger" {
  name = "${var.function_name}-trigger"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.trigger.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.function_queue.arn
}
