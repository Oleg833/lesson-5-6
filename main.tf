terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------- VPC (локальний модуль ./vpc) --------
module "vpc" {
  source = "./vpc"

  aws_region       = var.aws_region
  vpc_name         = var.vpc_name
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  environment      = var.environment
}

# -------- EKS (локальний модуль ./eks) --------
# Подаємо VPC виходи напряму (БЕЗ remote_state)
module "eks" {
  source = "./eks"

  aws_region      = var.aws_region
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  environment     = var.environment
  project         = var.project

  # <<< ключове: даємо EKS-у мережу з VPC
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # Параметри нод (підстав свої за потреби)
  mng_desired_size = var.mng_desired_size
  mng_min_size     = var.mng_min_size
  mng_max_size     = var.mng_max_size

  enable_small_node_group  = var.enable_small_node_group
  small_instance_types     = var.small_instance_types
  small_mng_desired_size   = var.small_mng_desired_size
  small_mng_min_size       = var.small_mng_min_size
  small_mng_max_size       = var.small_mng_max_size
}
