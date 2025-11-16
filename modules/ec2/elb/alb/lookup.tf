data "aws_region" "current" {}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "public_subnets" {
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
        "public-${count.index + 1}",
      module.global_settings.region_short_name)
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
