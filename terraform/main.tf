module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  cidr_block            = var.cidr_block
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  az_1                  = var.az_1
  az_2                  = var.az_2
  internet_cidr         = var.internet_cidr
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  kubernetes_version = var.kubernetes_version
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "sg" {
  source = "./modules/sg"

  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  eks_cluster_default_sg = module.eks.eks_cluster_sg_id
  port_https             = var.port_https
  port_http              = var.port_http
  port_kubelet           = var.port_kubelet
  port_DNS               = var.port_DNS
  port_rds               = var.port_rds
  internet_cidr          = var.internet_cidr
}

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  allocated_storage  = var.allocated_storage
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  username           = var.db_username
  password           = var.db_password
  rds_sg_id          = [module.sg.rds_sg_id]
}

module "pod_identity" {
  source = "./modules/pod-identity"

  project_name     = var.project_name
  domain_name      = var.domain_name
  eks_cluster_name = module.eks.eks_cluster_name
}