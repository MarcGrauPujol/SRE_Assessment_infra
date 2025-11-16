################################################################################
# VPC variables
################################################################################

variable "environment" {
  description = "Application environment (prd | stg | dev ...)"
  type        = string
  nullable    = false
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "main"
}