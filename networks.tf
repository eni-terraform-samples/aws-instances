locals {
  networks = {
    "${var.region}a" = "10.200.1.0/24"
    "${var.region}b" = "10.200.2.0/24"
    "${var.region}c" = "10.200.3.0/24"
  }
}

# VPC network
resource "aws_vpc" "main" {
  cidr_block = "10.200.0.0/16"
}

# internet gateway allows public IP for load-balancer
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

# create a subnet on each zone
resource "aws_subnet" "public_subnet" {
  for_each = local.networks

  availability_zone = each.key
  cidr_block        = each.value

  vpc_id = aws_vpc.main.id
}
