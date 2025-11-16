################################################################################
# Subnet
################################################################################
resource "aws_subnet" "this" {
  assign_ipv6_address_on_creation                = false
  availability_zone                              = data.aws_availability_zone.current.name
  cidr_block                                     = var.cidr
  map_public_ip_on_launch                        = var.map_public_ip_on_launch
  vpc_id                                         = var.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "subnet",
        var.vpc_name,
        format("%s-%s", var.subnet_type, var.availability_zone_idx),
        var.aws_region_mapping),
      Tier = var.subnet_type,
      Centralized_egress = var.centralized_egress
    },
    var.tags
  )
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "route-table",
        var.vpc_name,
        format("%s-%s", var.subnet_type, var.availability_zone_idx),
        var.aws_region_mapping)
    },
    var.tags
  )
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route" "public_internet_gateway_route" {
  count = startswith(var.subnet_type, "public") ? 1 : 0

  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id

  timeouts {
    create = "5m"
  }
}

################################################################################
# NAT Gateway. Creation only if public subnet
################################################################################

resource "aws_eip" "nat_eip" {

  count = startswith(var.subnet_type, "public") ? 1 : 0

  domain = "vpc"

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "eip",
        var.vpc_name,
        format("%s-%s", "nat-gateway", var.availability_zone_idx),
        var.aws_region_mapping)
    },
    var.tags
  )

  depends_on = [var.internet_gateway_id]
}

resource "aws_nat_gateway" "this" {
  count = startswith(var.subnet_type, "public") ? 1 : 0

  allocation_id = aws_eip.nat_eip[0].id
  subnet_id = aws_subnet.this.id

  tags = merge(
    {
      Name = format("%s-%s-%s-%s-%s-%s",
        var.environment,
        var.product,
        "nat-gateway",
        var.vpc_name,
        format("%s-%s", var.subnet_type, var.availability_zone_idx),
        var.aws_region_mapping)
    },
    var.tags
  )

  depends_on = [var.internet_gateway_id]
}

################################################################################
# NAT Gateway Routes. Creation only if private subnet
################################################################################
resource "aws_route" "nat_gateway_route" {
  count = startswith(var.subnet_type, "private") ? 1 : 0

  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id

  timeouts {
    create = "5m"
  }
}
