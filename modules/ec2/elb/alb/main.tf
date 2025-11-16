################################################################################
# EC2 - Application Load Balancer
################################################################################
locals {
  default_tags = {
    "Environment" = var.environment,
    "Product"     = var.product,
    "Region"      = data.aws_region.current.id
  }
}

################################################################################
# Global Settings
################################################################################
module "global_settings" {
  source = "../../../global_settings"
}

resource "aws_lb" "alb" {
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "alb",
    var.name,
  module.global_settings.region_short_name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  # ALB will be launched in public subnets
  subnets                    = data.aws_subnet.public_subnets.*.id
  enable_deletion_protection = false # For simplicity

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "alb",
        var.name,
      module.global_settings.region_short_name)
    },
    local.default_tags,
    var.tags
  )

  depends_on = [aws_security_group.alb_sg]
}

resource "aws_lb_target_group" "app_tg" {
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "tg",
    var.name,
  module.global_settings.region_short_name)
  port        = var.app_port # Internal port of the ECS tasks
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default_vpc.id
  target_type = "ip"

  health_check {
    path                = "/" # Checks the root path
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "tg",
        var.name,
      module.global_settings.region_short_name)
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port # Public port for the ALB
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "Not Found - No listener rule matched the request."
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "lb-listener",
        var.name,
      module.global_settings.region_short_name)
    },
    local.default_tags,
    var.tags
  )
}

resource "aws_lb_listener_rule" "root_path_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "lb-listener",
        var.name,
      module.global_settings.region_short_name)
    },
    local.default_tags,
    var.tags
  )
}
