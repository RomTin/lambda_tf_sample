/* ====================
Configuration
==================== */

terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = "2.21.1"
  region  = var.region
}

/* ====================
Modules
==================== */

module "lambda_function_sample" {
  source            = "./modules/lambda_function"
  function_name     = "sample"
  lambda_layer_arns = [module.lambda_layer_http.layer_arn]
  dlq_handler_arn   = module.lambda_function_dlq_handler.function_arn
}

module "lambda_layer_http" {
  source     = "./modules/lambda_layer"
  layer_name = "http_module"
}

module "lambda_function_dlq_handler" {
  source = "./modules/lambda_function_dlq_handler"
}

module "cloudwatch_dashboard" {
  source          = "./modules/cloudwatch_dashboard"
  sns_topic_names = [module.lambda_function_sample.sns_name]
  sqs_queue_names = [module.lambda_function_sample.sqs_name]
  dlq_queue_names = [module.lambda_function_sample.dlq_name]
  lambda_names    = [module.lambda_function_sample.function_name]
}

/* ====================
Argument variables
==================== */

variable "region" {
  type    = string
  default = "ap-northeast-1"
}