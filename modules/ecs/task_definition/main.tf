################################################################################
# ECS - Task Definition
################################################################################
locals {
  default_tags = {
    "Environment" = var.environment,
    "Product"     = var.product,
    "Region"      = data.aws_region.current.id
  }
}

resource "aws_ecs_task_definition" "app" {
  family = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "ecs-task",
    var.ecs_task_name,
  var.aws_region_mapping)

  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "ecs-container",
        var.ecs_task_name,
      var.aws_region_mapping)
      image     = var.app_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "ecs-task",
        var.ecs_task_name,
      var.aws_region_mapping)
    },
    local.default_tags,
    var.tags
  )
}

# Notes:
# I would have created log groups but I don't have permissions to do it.
