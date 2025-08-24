terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63"
    }
  }
}

########################################
# Provider
########################################
provider "aws" {
  region = var.aws_region
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
      ami_type       = "AL2_x86_64" # або "AL2023_x86_64_STANDARD"
      labels = { workload = "cpu" }
      tags   = { "k8s.io/cluster-autoscaler/enabled" = "true" }
    }
  }

  # Опційний дешевший пул (t3.small/t3.micro)
  small_mng = var.enable_small_node_group ? {
    cpu-nodes-small = {
      desired_size   = var.small_mng_desired_size
      min_size       = var.small_mng_min_size
      max_size       = var.small_mng_max_size
      instance_types = var.small_instance_types
      capacity_type  = "SPOT"        # або "ON_DEMAND"
      ami_type       = "AL2_x86_64"
      labels = { workload = "cpu-small" }
      taints = []
      tags   = { "k8s.io/cluster-autoscaler/enabled" = "true" }
    }
  } : {}

  managed_node_groups = merge(local.base_mng, local.small_mng)
}

########################################
# EKS Cluster (terraform-aws-modules/eks/aws v20)
########################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # стало (беремо з var.*)
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  enable_irsa = true

  # v20: правильний ключ для MNG
  eks_managed_node_groups = local.managed_node_groups

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project
  }
}

########################################
# Bootstrap доступу через EKS Access Entries (без aws-auth)
########################################
# Надаємо адміністраторські права твоєму ARN (root акаунта 876594438088)
resource "aws_eks_access_entry" "you_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::876594438088:root"
  type          = "STANDARD"
  depends_on    = [module.eks]
}

resource "aws_eks_access_policy_association" "you_admin_policy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.you_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.you_admin]
}
