variable "region" {
  type    = string
  default = "ap-northeast-1"
}
variable "sns_topic_names" {
  type = list
}

variable "sqs_queue_names" {
  type = list
}

variable "dlq_queue_names" {
  type = list
}

variable "lambda_names" {
  type = list
}
