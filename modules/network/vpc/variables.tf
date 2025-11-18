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
# VPC
################################################################################
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "main"
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  nullable    = false
}

variable "total_availability_zones" {
  description = "Number of availability zones to deploy subnets"
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
