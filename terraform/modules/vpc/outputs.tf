output "vpc_id" {
  description = "ID of the VPC"
  value = aws_vpc.main.id
}

output "igw_id" {
  description = "ID of Internet Gateway"
  value = aws_internet_gateway.igw.id
}

output "rnat_id" {
  description = "ID of Regional NAT Gateway"
  value = aws_nat_gateway.rnat.id
}

output "public_subnet_ids" {
  description = "ID's for both Public Subnets"
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

output "private_subnet_ids" {
  description = "ID's for both Private Subnets"
  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}