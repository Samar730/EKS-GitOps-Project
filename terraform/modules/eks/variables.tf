variable "project_name" {
    type = string
    default = "eks-memos"
}

variable "kubernetes_version" {
    type = string
    description = "Current k8s version for EKS Cluster"
    default = "1.35"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public Subnet IDs"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet IDs"
}

variable "admin_iam_arn" {
  type = string
  description = "IAM user ARN to grant cluster admin access"
}