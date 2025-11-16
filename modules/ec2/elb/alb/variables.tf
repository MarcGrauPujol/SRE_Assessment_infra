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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# ALB
################################################################################
variable "name" {
  description = "The name of the ALB."
  type        = string
}

variable "app_port" {
  description = "Application port exposed by the application container."
  type        = number
  default     = 5000
}

variable "listener_port" {
  description = "Listener port exposed by the ALB."
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol to be used."
  type = string
}

################################################################################
# VPC
################################################################################
variable "vpc_name" {
  description = "VPC Name."
  type        = string
  default     = "main"
}

variable "total_availability_zones" {
  description = "Number of availability zones to deploy subnets"
  type        = number
  default     = 2
}