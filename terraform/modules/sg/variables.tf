variable "project_name" {
    type = string
    default = "eks-memos"
}

variable "vpc_id" {
    type = string
    description = "ID of VPC"
}

variable "eks_cluster_default_sg" {
    type = string
    description = "SG for the EKS Cluster"
}

variable "port_https" {
    type = number
    description = "Port Number for HTTPS"
    default = 443
}

variable "port_http" {
    type = number
    description = "Port Number for HTTP"
    default = 80
}

variable "port_kubelet" {
    type = number
    description = "Port Number the Kubelet listens on"
    default = 10250
}

variable "port_DNS" {
    type = number
    description = "Port Number for DNS"
    default = 53
}

variable "port_rds" {
    type = number
    description = "Port Number for RDS for PostgreSQL"
    default = 5432
}

variable "internet_cidr" {
    type = string
    description = "CIDR range for Internet"
    default = "0.0.0.0/0"
}