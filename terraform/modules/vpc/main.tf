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

# Public subnets for both AZ's (A & B)
resource "aws_subnet" "public_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_a_cidr
    availability_zone = var.az_1
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project_name}-public_subnet_a"
    }
}

resource "aws_subnet" "public_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_b_cidr
    availability_zone = var.az_2
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.project_name}-public_subnet_b"
    }
}

# Private Subnets for both AZ'S (A & B)
resource "aws_subnet" "private_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_a_cidr
    availability_zone = var.az_1
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.project_name}-private_subnet_a"
    }
}

resource "aws_subnet" "private_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_b_cidr
    availability_zone = var.az_2
    map_public_ip_on_launch = false
    
    tags = {
      Name = "${var.project_name}-private_subnet_b"
    }
}

# Public Subnet Route Table -> IGW
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = var.internet_cidr
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.project_name}-public_rt"
    }
}

# Private Subnet Route Table -> Regional NAT Gateway
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.internet_cidr
        nat_gateway_id = aws_nat_gateway.rnat.id
    }   

    tags = {
      Name = "${var.project_name}-private_rt"
    }
}

# Public Route Table Associations -> Public Subnets A & B 
resource "aws_route_table_association" "public_subnet_associations_a" {
    subnet_id = aws_subnet.public_subnet_a.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_associations_b" {
    subnet_id = aws_subnet.public_subnet_b.id
    route_table_id = aws_route_table.public_rt.id
}

# Private Route Table Associations -> Private Subnets A & B
resource "aws_route_table_association" "private_subnet_associations_a" {
    subnet_id = aws_subnet.private_subnet_a.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_associations_b" {
    subnet_id = aws_subnet.private_subnet_b.id
    route_table_id = aws_route_table.private_rt.id    
}