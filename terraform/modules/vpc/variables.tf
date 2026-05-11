variable "cidr_block" {
    type = string
    description = "CIDR Block range for VPC"
    default = "10.0.0.0/16"
}

variable "project_name" {
    type = string
    description = "Name for EKS Project"
    default = "eks-memos"
}

variable "public_subnet_a_cidr" {
    type = string
    description = "CIDR block range for Public Subnet A"
    default = "10.0.1.0/24"
}
variable "public_subnet_b_cidr" {
    type = string
    description = "CIDR block range for Public Subnet B"
    default = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
    type = string
    description = "CIDR block range for Private Subent B"
    default = "10.0.3.0/24"
}

variable "private_subnet_b_cidr" {
    type = string
    description = "CIDR block range for Private Subent B"
    default = "10.0.4.0/24"
}

variable "az_1" {
    type = string
    default = "eu-west-2a"
}

variable "az_2" {
    type = string
    default = "eu-west-2b"
}

variable "internet_cidr" {
    type = string
    description = "CIDR range for Internet route"
    default = "0.0.0.0/0"
}