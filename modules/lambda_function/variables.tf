/* ====================
Argument variables
==================== */

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "function_name" {
  type = string
}

variable "lambda_layer_arns" {
  type    = list
  default = []
}

variable "timeout" {
  type    = string
  default = "60"
}

variable "memory" {
  type    = string
  default = "128"
}

variable "concurrent_limitation" {
  type    = string
  default = "-1"
}

variable "dlq_handler_arn" {
  type    = string
  default = ""
}
