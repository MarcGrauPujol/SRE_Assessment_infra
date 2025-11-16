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

variable "aws_region_mapping" {
  description = "AWS region mapping."
  type        = string
  nullable    = false
}

################################################################################
# ECS - Service
################################################################################
variable "name" {
  description = "The name of the service."
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster where the service will be deployed."
  type        = string
}

variable "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition to use for the service."
  type        = string
}

variable "launch_type" {
  description = "The launch type on which to run your service. Valid values are EC2 and FARGATE."
  type        = string
  default     = "FARGATE"
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to 0."
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Application port exposed by the application container."
  type        = number
  default     = 5000
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  type        = string
  default     = "TASK_DEFINITION"
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