# -------------------------
# VPC Outputs
# -------------------------
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# -------------------------
# Public Subnet Outputs
# -------------------------
output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = { for k, v in aws_subnet.public : k => v.cidr_block }
}

# -------------------------
# Private Subnet Outputs
# -------------------------
output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = { for k, v in aws_subnet.private : k => v.id }
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = { for k, v in aws_subnet.private : k => v.cidr_block }
}

# -------------------------
# Internet Gateway
# -------------------------
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

# -------------------------
# NAT Gateway
# -------------------------
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat.id
}

output "nat_eip" {
  description = "Elastic IP of NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

# -------------------------
# Route Tables
# -------------------------
output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.private_rt.id
}