################################################################################
# ALB Security Groups
################################################################################
resource "aws_security_group" "alb_sg" {
  vpc_id = data.aws_vpc.default_vpc.id
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "security-group-alb",
    var.name,
  module.global_settings.region_short_name)
  description = "Allow ${var.protocol} port ${var.listener_port}."

  ingress {
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
