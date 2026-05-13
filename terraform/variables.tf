variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "eks-memos"
}

# VPC Variables
variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "az_1" {
  type    = string
  default = "eu-west-2a"
}

variable "az_2" {
  type    = string
  default = "eu-west-2b"
}

variable "internet_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

# SG Variables
variable "port_https" {
  type    = number
  default = 443
}

variable "port_http" {
  type    = number
  default = 80
}

variable "port_kubelet" {
  type    = number
  default = 10250
}

variable "port_DNS" {
  type    = number
  default = 53
}

variable "port_rds" {
  type    = number
  default = 5432
}

# EKS Variables
variable "kubernetes_version" {
  type    = string
  default = "1.35"
}

# RDS Variables
variable "allocated_storage" {
  type    = number
  default = 20
}

variable "engine_version" {
  type    = string
  default = "16.3"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

# Pod Identity Variables
variable "domain_name" {
  type    = string
  default = "cloudbysamar.com"
}