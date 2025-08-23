terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

########################################
# Providers
########################################
provider "aws" {
  region = var.aws_region
}

########################################
# Remote state VPC (S3 backend)
########################################
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_bucket     # напр. "tf-states-876594438088"
    key    = var.vpc_state_key        # напр. "network/vpc.tfstate"
    region = var.vpc_state_region     # напр. "eu-central-1"
  }
}

########################################
# Локальні мапи для EKS Managed Node Groups
########################################
locals {
  # Основний пул CPU (t3.medium)
  base_mng = {
    cpu-nodes = {
      desired_size   = var.mng_desired_size
      min_size       = var.mng_min_size
      max_size       = var.mng_max_size
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2_x86_64"
      labels = {
        workload = "cpu"
      }
      tags = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  }

  # Опційний дешевший пул (t3.small/t3.micro)
  small_mng = var.enable_small_node_group ? {
    cpu-nodes-small = {
      desired_size   = var.small_mng_desired_size
      min_size       = var.small_mng_min_size
      max_size       = var.small_mng_max_size
      instance_types = var.small_instance_types   # напр. ["t3.small"] або ["t3.micro"]
      capacity_type  = "SPOT"
      ami_type       = "AL2_x86_64"
      labels = {
        workload = "cpu-small"
      }
      taints = [] # додайте за потреби
      tags = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  } : {}

  managed_node_groups = merge(local.base_mng, local.small_mng)
}

########################################
# EKS Cluster (terraform-aws-modules/eks/aws v20)
########################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Мережа з VPC remote state
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  # Доступ до API
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  # IRSA для сервіс-акаунтів
  enable_irsa = true

  # ✅ v20: нова назва аргументу для node groups
  eks_managed_node_groups = local.managed_node_groups

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project
  }
}

########################################
# AWS Auth ConfigMap (окремий підмодуль у v20)
########################################
module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  create_aws_auth_configmap = true
  enable_cluster_creator_admin_permissions = true

  # опційно додати ролі/користувачів:
  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>"
  #     username = "role:<ROLE_NAME>"
  #     groups   = ["system:masters"]
  #   }
  # ]
  # aws_auth_users    = []
  # aws_auth_accounts = []

  depends_on = [module.eks]
}
