# IAM role for EKS Control Plane
resource "aws_iam_role" "cluster_iam" {
    name = "${var.project_name}-cluster-iam-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_iam.name
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
    name = "${var.project_name}-cluster"
    role_arn = aws_iam_role.cluster_iam.arn
    version = var.kubernetes_version

    access_config {
      authentication_mode = "API"
      bootstrap_cluster_creator_admin_permissions = true # Grants the cluster creator full admin access automatically
    }

    vpc_config {
        subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
        endpoint_private_access = true
        endpoint_public_access  = true
    }

    depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# Node Groups -> IAM Role permissions for Node Groups must be created first 
resource "aws_iam_role" "nodes_iam" {
  name = "${var.project_name}-nodes-iam-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_iam.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_iam.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_iam.name
}

# Node Groups Resource
resource "aws_eks_node_group" "main" {
    cluster_name = aws_eks_cluster.main.name
    node_group_name = "${var.project_name}-node-group"
    node_role_arn = aws_iam_role.nodes_iam.arn
    subnet_ids = var.private_subnet_ids

    scaling_config {
        desired_size = 2
        max_size = 3
        min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

     depends_on = [
        aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# EKS addons
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  depends_on = [ aws_eks_node_group.main ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "pod_identity" {
  cluster_name = aws_eks_cluster.main.name
  addon_name = "eks-pod-identity-agent"
}

# EKS OIDC Provider — enables Pod Identity so pods can assume IAM roles
# Dynamically reads the OIDC issuer URL from the cluster so it stays in sync
# across destroy/recreate cycles without manual intervention
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# Grant local IAM user admin access to the cluster
# Required because the cluster is provisioned via GitHub Actions pipeline (OIDC role)
# which means only the pipeline role gets access by default — not the local IAM user
resource "aws_eks_access_entry" "admin" {
  cluster_name = aws_eks_cluster.main.name
  principal_arn = var.admin_iam_arn
}

# Associate cluster admin policy to the IAM user
# AmazonEKSClusterAdminPolicy grants full cluster-wide kubectl access
resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_iam_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}