output "eks_nodes_sg_id" {
  description = "ID of EKS Nodes SG"
  value = aws_security_group.eks_nodes.id
}

output "rds_sg_id" {
  description = "ID of RDS SG"
  value = aws_security_group.rds.id
}