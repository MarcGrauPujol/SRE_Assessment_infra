# ################################################################
# ## Subnet Outputs
# ################################################################

output "nat_gateway_id" {
  value = startswith(var.subnet_type, "public") ? aws_nat_gateway.this[0].id : null
}
