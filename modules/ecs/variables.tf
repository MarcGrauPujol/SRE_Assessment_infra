################################################################################
# Global
################################################################################
variable "environment" {
  description = "Application environment (prd | stg | dev | ... )"
  type        = string
  nullable    = false
}

variable "product" {
  description = "Application/Project name"
  type        = string
  nullable    = false
}

################################################################################
# ECS
################################################################################
variable "name" {
  description = "The name of the ECS task definition."
  type        = string
}

variable "app_image" {
  description = "The application image."
  type        = string
}
