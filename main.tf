terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

############################
# Module: VPC
############################
module "vpc" {
  source = "./vpc"

  aws_region      = var.aws_region
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  environment     = var.environment
}

############################
# Module: EKS
############################
module "eks" {
  source = "./eks"

  # Backend VPC state, який читає eks/data.terraform_remote_state
  aws_region       = var.aws_region
  vpc_state_bucket = var.vpc_state_bucket
  vpc_state_key    = var.vpc_state_key
  vpc_state_region = var.vpc_state_region

  # Кластер
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  environment     = var.environment
  project         = var.project

  # Node groups
  mng_desired_size = var.mng_desired_size
  mng_min_size     = var.mng_min_size
  mng_max_size     = var.mng_max_size

  enable_small_node_group = var.enable_small_node_group
  small_instance_types    = var.small_instance_types
  small_mng_desired_size  = var.small_mng_desired_size
  small_mng_min_size      = var.small_mng_min_size
  small_mng_max_size      = var.small_mng_max_size
}
