############################
# AWS / Global
############################
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "aws-baseline"
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "dev"
}

############################
# VPC
############################
variable "vpc_name" {
  type        = string
  default     = "prod-vpc"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

############################
# EKS cluster
############################
variable "cluster_name" {
  type        = string
  default     = "eks-baseline"
}

variable "cluster_version" {
  type        = string
  default     = "1.29"
}

############################
# VPC remote state for EKS
############################
variable "vpc_state_bucket" {
  type        = string
  default     = "tf-states-876594438088"
}

variable "vpc_state_key" {
  type        = string
  default     = "network/vpc.tfstate"
}

variable "vpc_state_region" {
  type        = string
  default     = "eu-central-1"
}

############################
# Node groups (main)
############################
variable "mng_desired_size" {
  type    = number
  default = 2
}

variable "mng_min_size" {
  type    = number
  default = 1
}

variable "mng_max_size" {
  type    = number
  default = 4
}

############################
# Node groups (small/optional)
############################
variable "enable_small_node_group" {
  type    = bool
  default = true
}

variable "small_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "small_mng_desired_size" {
  type    = number
  default = 1
}

variable "small_mng_min_size" {
  type    = number
  default = 0
}

variable "small_mng_max_size" {
  type    = number
  default = 2
}
