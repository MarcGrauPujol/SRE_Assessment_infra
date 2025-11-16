################################################################################
# ALB variables
################################################################################
variable "environment" {
  description = "Application environment (prd | stg | dev ...)"
  type        = string
  nullable    = false
}
