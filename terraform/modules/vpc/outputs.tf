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