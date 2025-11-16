resource "aws_security_group" "fargate_sg" {
  vpc_id = data.aws_vpc.default_vpc.id
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "security-group-fargate",
    var.name,
  var.aws_region_mapping)
  description = "Allows ingress traffic only from ALB to Fargate tasks"

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [data.aws_security_group.alb_myapp_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
