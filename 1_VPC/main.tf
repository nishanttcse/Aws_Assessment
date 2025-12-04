provider "aws" {
  region = var.region
}

locals {
  prefix = var.prefix
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  tags = { Name = "${local.prefix}_vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${local.prefix}_igw" }
}

# Public subnets
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "${local.prefix}_public_a" }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = { Name = "${local.prefix}_public_b" }
}

# Private subnets
resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.101.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "${local.prefix}_private_a" }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.10.102.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = { Name = "${local.prefix}_private_b" }
}

# Data source for AZs
data "aws_availability_zones" "available" {}

# Route tables - public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${local.prefix}_public_rt" }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${local.prefix}_nat_eip"
  }
}

# NAT Gateway in public_a
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_a.id
  tags = { Name = "${local.prefix}_nat" }
  depends_on = [aws_internet_gateway.igw]
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${local.prefix}_private_rt" }
}
resource "aws_route_table_association" "private_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

output "vpc_id" { value = aws_vpc.main.id }
output "public_subnets" { value = [aws_subnet.public_a.id, aws_subnet.public_b.id] }
output "private_subnets" { value = [aws_subnet.private_a.id, aws_subnet.private_b.id] }
