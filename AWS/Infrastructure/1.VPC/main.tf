terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Define the provider with a region variable
provider "aws" {
  region  = var.region
  profile = var.profile
}

# Create a VPC
resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Create subnets
resource "aws_subnet" "subnets" {
  count             = length(var.subnet_names)
  vpc_id            = aws_vpc.vpc_name.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags = {
    Name = var.subnet_names[count.index]
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_name.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.public_subnet_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

# Create private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Associate private subnets to private route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.subnet_names)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  depends_on     = [aws_route_table.private_route_table, aws_subnet.subnets]
}

# Associate public subnet to public route table
resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
  depends_on     = [aws_route_table.public_route_table, aws_subnet.public_subnet]
}

# Create an Elastic IP for NAT Gateway
resource "aws_eip" "elastic_ip_for_nat" {
  vpc                      = true
  associate_with_private_ip = "10.0.8.6"

  tags = {
    Name = "NAT gateway Public IP"
  }

  depends_on = [aws_internet_gateway.ig]
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat.id
  subnet_id      = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.vpc_name}-NAT-gw"
  }

  depends_on = [aws_eip.elastic_ip_for_nat]
}

# Associate NAT Gateway to private route table
resource "aws_route" "nat_gateway_route" {
  route_table_id            = aws_route_table.private_route_table.id
  nat_gateway_id            = aws_nat_gateway.nat_gateway.id
  destination_cidr_block    = "0.0.0.0/0"
}

#create a internet gateway and attach to VPC
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    "Name" = "${var.vpc_name}-igw"
  }
}

#Associate Internet Gateway to Subnets 
resource "aws_route" "public_internet_gateway_route" {
  route_table_id = aws_route_table.public_route_table.id
  gateway_id = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}