###VPC#####
resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}
#SUBNETS#
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}
#  resource "aws_subnet" "public" {
#   count = length(var.public_subnet_cidrs)

#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = var.public_subnet_cidrs[count.index]
#   availability_zone       = var.availability_zones[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${var.vpc_name}-public-${count.index + 1}"
#   }
# }

# resource "aws_subnet" "private" {
#   count = length(var.private_subnet_cidrs)

#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.private_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name = "${var.vpc_name}-private-${count.index + 1}"
#   }
# }

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}
# -------------------------
# Elastic IP for NAT Gateway
# -------------------------
resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-NAT-EIP"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}
# -------------------------
# NAT Gateway
# -------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public["public-1"].id

  tags = {
    Name = "${var.vpc_name}-NAT-Gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}
# -------------------------
# Public Route Table
# -------------------------
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-Public-RT"
  }
}


# -------------------------
# Private Route Table
# -------------------------
resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.vpc_name}-Private-RT"
  }
}
# Route Table Associations

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}# -------------------------
