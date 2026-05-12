# Node SG 
resource "aws_security_group" "eks_nodes" {
    name = "${var.project_name}-eks-nodes-sg"
    description = "Security Group for EKS nodes"
    vpc_id = var.vpc_id

    tags = {
      Name = "${var.project_name}-eks-nodes-sg"
    }
}

# 3 Ingress rules / Egress -> Internet

# Nodes accepting traffic from Cluster SG (Control Plane)
resource "aws_vpc_security_group_ingress_rule" "cluster_to_node" {
    security_group_id = aws_security_group.eks_nodes.id
    referenced_security_group_id = var.eks_cluster_default_sg

    from_port = var.port_https
    to_port = var.port_https
    ip_protocol = "tcp"
}

# Kubelet (Nodes) accepting traffic from Cluster SG (Control Plane) on Port 10250
resource "aws_vpc_security_group_ingress_rule" "cluster_to_kubelet" {
    security_group_id = aws_security_group.eks_nodes.id
    referenced_security_group_id = var.eks_cluster_default_sg

    from_port = var.port_kubelet
    to_port = var.port_kubelet
    ip_protocol = "tcp"
}

# Node to Node TCP/UDP Traffic (DNS Port 53)
resource "aws_vpc_security_group_ingress_rule" "node_to_node_tcp" {
    security_group_id = aws_security_group.eks_nodes.id
    referenced_security_group_id = aws_security_group.eks_nodes.id

    from_port = var.port_DNS
    to_port = var.port_DNS
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "node_to_node_udp" {
    security_group_id = aws_security_group.eks_nodes.id
    referenced_security_group_id = aws_security_group.eks_nodes.id

    from_port = var.port_DNS 
    to_port = var.port_DNS
    ip_protocol = "udp"
}

# Nodes accepting inbound traffic from NLB (HTTP/HTTPS)
resource "aws_vpc_security_group_ingress_rule" "nlb_to_node_https" {
    security_group_id = aws_security_group.eks_nodes.id
    cidr_ipv4 = var.internet_cidr

    from_port = var.port_https
    to_port = var.port_https
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nlb_to_node_http" {
    security_group_id = aws_security_group.eks_nodes.id
    cidr_ipv4 = var.internet_cidr

    from_port = var.port_http
    to_port = var.port_http
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "nodes_egress_to_all" {
    security_group_id = aws_security_group.eks_nodes.id
    cidr_ipv4 = var.internet_cidr
    ip_protocol = "-1"
}

# RDS Security Group 
resource "aws_security_group" "rds" {
    name = "${var.project_name}-rds-sg"
    description = "Security Group for RDS"
    vpc_id = var.vpc_id

    tags = {
      Name = "${var.project_name}-rds-sg"
    }
}

# RDS SG Ingress -> only accepts inbound traffic from the node SG on port 5432
resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress" {
    security_group_id = aws_security_group.rds.id
    referenced_security_group_id = aws_security_group.eks_nodes.id

    from_port = var.port_rds
    to_port = var.port_rds
    ip_protocol = "tcp"    
}

resource "aws_vpc_security_group_egress_rule" "rds_sg_egress_all" {
    security_group_id = aws_security_group.rds.id
    cidr_ipv4 = var.internet_cidr
    ip_protocol = "-1"
}