output "eks_cluster_name" {
  description = "Name of EKS Cluster"
  value = aws_eks_cluster.main.name
}

output "eks_cluster_sg_id" {
    description = "EKS Cluster Security Group ID"
    value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}