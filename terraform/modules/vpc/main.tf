# VPC Resource
resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "${var.project_name}-vpc"
    }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "${var.project_name}-igw"
    }
}

# Regional NAT Gateway
resource "aws_nat_gateway" "rnat" {
    vpc_id = aws_vpc.main.id
    availability_mode = "regional"

    tags = {
      Name = "${var.project_name}-rnat"
    }

    depends_on = [ aws_internet_gateway.igw ]
}

