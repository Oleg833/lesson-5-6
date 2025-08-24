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
  description = "Project tag (наприклад для Cost Allocation)"
  default     = "aws-baseline"
}

variable "environment" {
  type        = string
  description = "Environment tag (dev/stage/prod)"
  default     = "dev"
}

############################
# VPC
############################
variable "vpc_name" {
  type        = string
  description = "Назва VPC"
  default     = "prod-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR-блок для VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones для використання у VPC"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR блоки для приватних сабнетів"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR блоки для публічних сабнетів"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

############################
# EKS cluster
############################
variable "cluster_name" {
  type        = string
  description = "Назва EKS кластеру"
  default     = "eks-baseline"
}

variable "cluster_version" {
  type        = string
  description = "Версія Kubernetes для EKS"
  default     = "1.29"
}

############################
# Node groups (main)
############################
variable "mng_desired_size" {
  type        = number
  description = "Бажана кількість нод у основному node group"
  default     = 2
}

variable "mng_min_size" {
  type        = number
  description = "Мінімальна кількість нод у основному node group"
  default     = 1
}

variable "mng_max_size" {
  type        = number
  description = "Максимальна кількість нод у основному node group"
  default     = 4
}

############################
# Node groups (small/optional)
############################
variable "enable_small_node_group" {
  type        = bool
  description = "Чи створювати додатковий малий node group"
  default     = true
}

variable "small_instance_types" {
  type        = list(string)
  description = "EC2 типи для малого node group"
  default     = ["t3.small"]
}

variable "small_mng_desired_size" {
  type        = number
  description = "Бажана кількість нод у малому node group"
  default     = 1
}

variable "small_mng_min_size" {
  type        = number
  description = "Мінімальна кількість нод у малому node group"
  default     = 0
}

variable "small_mng_max_size" {
  type        = number
  description = "Максимальна кількість нод у малому node group"
  default     = 2
}
