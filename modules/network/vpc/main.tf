locals {
  default_tags = {
    "Environment" = var.environment,
    "Product"     = var.product,
    "Region"      = data.aws_region.current.id
  }

  vpc_id         = data.aws_vpc.default_vpc.id

  zone_ids = data.aws_availability_zones.available.zone_ids
  azs      = slice(sort(local.zone_ids), 0, var.total_availability_zones)

  # NOTE 1:
  # I'm using /24 for both public and private subnets for simplicity.
  # The first free address in the VPC is 172.31.48.0, that's why I'm starting with that one.

  # -------------------------------
  # Public subnets (/24)
  # -------------------------------
  cidr_public_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, 48 + k)]

  # -------------------------------
  # Private subnets (/24)
  # -------------------------------
  cidr_private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, 50 + k)]
}

module "global_settings" {
  source = "../../global_settings"
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc_id
  tags   = merge(
    {
      Name = format("%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "igw",
        var.vpc_name,
        module.global_settings.region_short_name)
    },
    local.default_tags,
    var.tags
  )
}

################################################################################
# Public Subnets
################################################################################
module "public_subnet" {
  source = "./subnet"
  count  = var.total_availability_zones

  product               = var.product
  environment           = var.environment
  aws_region_mapping    = module.global_settings.region_short_name
  availability_zone_id  = local.azs[count.index]
  availability_zone_idx = count.index + 1
  cidr                  = local.cidr_public_subnets[count.index]
  subnet_type           = "public"
  vpc_id                = local.vpc_id
  vpc_name              = var.vpc_name
  internet_gateway_id   = aws_internet_gateway.this.id
  tags                  = merge(local.default_tags, var.tags)

  depends_on = [aws_internet_gateway.this]
}

################################################################################
# Private Subnets
################################################################################
module "private_subnet" {
  source = "./subnet"
  count  = var.total_availability_zones

  product               = var.product
  environment           = var.environment
  aws_region_mapping    = module.global_settings.region_short_name
  availability_zone_id  = local.azs[count.index]
  availability_zone_idx = count.index + 1
  cidr                  = local.cidr_private_subnets[count.index]
  subnet_type           = "private"
  vpc_id                = local.vpc_id
  vpc_name              = var.vpc_name
  nat_gateway_id        = module.public_subnet[count.index].nat_gateway_id
  tags                  = merge(local.default_tags, var.tags)

  depends_on = [
    module.public_subnet
  ]
}

# NOTE 2:
# I would have created VPC flow logs but I don't have permissions to do so in this environment.
#
# NOTE 3:
# I'm using the default ACL, but in a real-world scenario, I would create custom ACLs for better security.