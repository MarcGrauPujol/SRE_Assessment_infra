################################################################################
# ECS - Task Service
################################################################################
resource "aws_ecs_service" "app_service" {
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "ecs-service",
    var.name,
  var.aws_region_mapping)

  cluster         = var.ecs_cluster_id
  task_definition = var.ecs_task_definition_arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type
  propagate_tags  = var.propagate_tags

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [aws_security_group.fargate_sg.id]
    # Tasks will be launched in private subnets
    subnets          = data.aws_subnet.private_subnets.*.id
    assign_public_ip = false # Don't need public IPs for Fargate tasks in private subnets. NAT Gateway will handle outbound traffic.
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.alb_myapp_tg.arn
    container_name = format("%s-%s-%s-%s-%s",
      var.environment,
      var.product,
      "ecs-container",
      var.name,
    var.aws_region_mapping)
    container_port = var.app_port
  }

  depends_on = [aws_security_group.fargate_sg]
}
