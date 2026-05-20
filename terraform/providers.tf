terraform {
  backend "s3" {
    bucket       = "eks-memos-tfstate"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}