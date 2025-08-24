########################################
# AWS
########################################
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

########################################
# Cluster params
########################################
variable "cluster_name" {
  description = "Назва EKS кластера"
  type        = string
  default     = "eks-baseline"

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name не може бути порожнім."
  }
}

variable "cluster_version" {
  description = "Версія Kubernetes/EKS"
  type        = string
  default     = "1.29"
}

variable "environment" {
  description = "Середовище (dev/stage/prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Назва проєкту (для тегів)"
  type        = string
  default     = "aws-baseline"
}

########################################
# Node Group - main (t3.medium)
########################################
variable "mng_desired_size" {
  type        = number
  default     = 2
}

variable "mng_min_size" {
  type        = number
  default     = 1
}

variable "mng_max_size" {
  type        = number
  default     = 4
}

########################################
# Node Group - small (t3.small/micro)
########################################
variable "enable_small_node_group" {
  type        = bool
  default     = true
}

variable "small_instance_types" {
  type        = list(string)
  default     = ["t3.small"]
}

variable "small_mng_desired_size" {
  type        = number
  default     = 1
}

variable "small_mng_min_size" {
  type        = number
  default     = 0
}

variable "small_mng_max_size" {
  type        = number
  default     = 2
}

########################################
# Network (отримується з root)
########################################
variable "vpc_id" {
  type        = string
  description = "VPC ID для EKS"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Список приватних сабнетів для EKS"
}


