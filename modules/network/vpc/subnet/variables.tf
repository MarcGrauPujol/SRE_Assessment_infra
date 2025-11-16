################################################################################
# Global
################################################################################
variable "product" {
  description = "Application / Project name"
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Application environment (prd | stg | dev | ...)"
  type        = string
  nullable    = false
}

variable "aws_region_mapping" {
  description = "AWS region mapping."
  type        = string
  nullable    = false
}

################################################################################
# Subnet
################################################################################
variable "cidr" {
  description = "The IPv4 CIDR block for the Subnet."
  type        = string
  nullable    = false
}

variable "availability_zone_id" {
  description = "The AZ Id for the Subnet."
  type        = string
  nullable    = false
}

variable "availability_zone_idx" {
  description = "The AZ index."
  type        = number
  nullable    = false
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`"
  type        = bool
  default    = false
}

variable "vpc_name" {
  description = "The VPC name"
  type        = string
  nullable    = false
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  nullable    = false
}

variable "subnet_type" {
  description = "The subnet type."
  type = string

  validation {
    condition = contains([
      "public",
      "private"
    ], var.subnet_type)
    error_message = "Subnet type not valid"
  }
}

variable "internet_gateway_id" {
  description = "The Internet gateway id"
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "The NAT gateway id"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "centralized_egress" {
  description = "Set to true if you want to use a centralized egress."
  type        = bool
  default     = false
}