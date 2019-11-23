/* ====================
Resources
==================== */

data "template_file" "dashboard" {
  template = file("${path.module}/templates/cloudwatch_dashboard.json")

  vars = {
    lambda_invocations = jsonencode(local.lambda_invocations)
    lambda_errors      = jsonencode(local.lambda_errors)
    lambda_counts      = jsonencode(concat(local.lambda_invocations, local.lambda_errors))
    sns_published      = jsonencode(local.sns_published)
    sns_failed         = jsonencode(local.sns_failed)
    sns_delivered      = jsonencode(local.sns_delivered)
    sqs_sent           = jsonencode(local.sqs_sent)
    sqs_delayed        = jsonencode(local.sqs_delayed)
    sqs_received       = jsonencode(local.sqs_received)
    sqs_deleted        = jsonencode(local.sqs_deleted)
    dlq_sent           = jsonencode(local.dlq_sent)
    dlq_delayed        = jsonencode(local.dlq_delayed)
    dlq_received       = jsonencode(local.dlq_received)
    dlq_deleted        = jsonencode(local.dlq_deleted)
  }
}

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "main"
  dashboard_body = data.template_file.dashboard.rendered
}



locals {
  lambda_invocations = [for n in var.lambda_names : ["AWS/Lambda", "Invocations", "FunctionName", n, { "label" : "呼び出し: ${n}" }]]
  lambda_errors      = [for n in var.lambda_names : ["AWS/Lambda", "Errors", "FunctionName", n, { "label" : "エラー: ${n}" }]]
  sns_published      = [for n in var.sns_topic_names : ["AWS/SNS", "NumberOfMessagesPublished", "TopicName", n, { "label" : n }]]
  sns_failed         = [for n in var.sns_topic_names : ["AWS/SNS", "NumberOfNotificationsFailed", "TopicName", n, { "label" : n }]]
  sns_delivered      = [for n in var.sns_topic_names : ["AWS/SNS", "NumberOfNotificationsDelivered", "TopicName", n, { "label" : n }]]
  sqs_sent           = [for n in var.sqs_queue_names : ["AWS/SQS", "NumberOfMessagesSent", "QueueName", n, { "label" : n }]]
  sqs_delayed        = [for n in var.sqs_queue_names : ["AWS/SQS", "ApproximateNumberOfMessagesDelayed", "QueueName", n, { "label" : n }]]
  sqs_received       = [for n in var.sqs_queue_names : ["AWS/SQS", "NumberOfMessagesReceived", "QueueName", n, { "label" : n }]]
  sqs_deleted        = [for n in var.sqs_queue_names : ["AWS/SQS", "NumberOfMessagesDeleted", "QueueName", n, { "label" : n }]]
  dlq_sent           = [for n in var.dlq_queue_names : ["AWS/SQS", "NumberOfMessagesSent", "QueueName", n, { "label" : n }]]
  dlq_delayed        = [for n in var.dlq_queue_names : ["AWS/SQS", "ApproximateNumberOfMessagesDelayed", "QueueName", n, { "label" : n }]]
  dlq_received       = [for n in var.dlq_queue_names : ["AWS/SQS", "NumberOfMessagesReceived", "QueueName", n, { "label" : n }]]
  dlq_deleted        = [for n in var.dlq_queue_names : ["AWS/SQS", "NumberOfMessagesDeleted", "QueueName", n, { "label" : n }]]
}
