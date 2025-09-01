output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.this.id
}

output "public_rt_id" {
  value = aws_route_table.public.id
}

output "private_rt_id" {
  value = aws_route_table.private.id
}

# Map with stable keys to avoid unknown for_each keys later
output "route_tables_map" {
  value = {
    public  = aws_route_table.public.id
    private = aws_route_table.private.id
  }
}
