data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "private_subnets" {
  count = var.total_availability_zones

  vpc_id = data.aws_vpc.default_vpc.id

  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "subnet",
        var.vpc_name,
        "private-${count.index + 1}",
      var.aws_region_mapping)
    ]
  }

  filter {
    name   = "tag:Product"
    values = [var.product]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_security_group" "alb_myapp_sg" {
  name = format("%s-%s-%s-%s-%s",
    var.environment,
    var.product,
    "security-group-alb",
    "api",
  var.aws_region_mapping)
}

data "aws_lb_target_group" "alb_myapp_tg" {
  name = format("%s-%s-%s-%s",
    var.environment,
    var.product,
    "tg-api",
  var.aws_region_mapping)
}
