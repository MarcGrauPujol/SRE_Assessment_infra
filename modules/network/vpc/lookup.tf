data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

data "aws_vpc" "default_vpc" {
  default = true
}
