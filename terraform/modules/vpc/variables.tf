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