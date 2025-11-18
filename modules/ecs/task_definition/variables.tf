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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# ECS
################################################################################
variable "ecs_task_name" {
  description = "The name of the ECS task definition."
  type        = string
}

variable "app_image" {
  description = "The image of the application container."
  type        = string
}

variable "app_port" {
  description = "Application port exposed by the application container."
  type        = number
  default     = 5000
}

variable "requires_compatibilities" {
  description = "The launch type required by the task."
  type        = list(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "The number of cpu units used by the task."
  type        = number
  default     = 256 # 0.25 vCPU
}

variable "memory" {
  description = "The amount of memory (in MiB) used by the task."
  type        = number
  default     = 512 # 0.5 GB RAM
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task."
  type        = string
  default     = "awsvpc" # Required for Fargate
}

# Note:
# Once again, for convenience, I have left the default values that I need for this specific example. Normally, all product configurations would need to be defined in the configuration file and the value passed through variables.