########################################
# AWS & Backend
########################################
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_state_bucket" {
  description = "S3 bucket з Terraform state VPC"
  type        = string
  default     = "tf-states-876594438088"
}

variable "vpc_state_key" {
  description = "Шлях до state VPC у S3"
  type        = string
  default     = "network/vpc.tfstate"
}

variable "vpc_state_region" {
  description = "Регіон S3 bucket зі state VPC"
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

  # Дозволяємо формати типу 1.28 / 1.29 / 1.30
  validation {
    condition     = can(regex("^1\\.(2[8-9]|3[0-9])$", var.cluster_version))
    error_message = "cluster_version має бути у форматі 1.28, 1.29, 1.30 тощо."
  }
}

variable "environment" {
  description = "Середовище (dev/stage/prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment має бути одним із: dev, stage, prod."
  }
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
  description = "Бажана кількість нод у основному node group"
  type        = number
  default     = 2
}

variable "mng_min_size" {
  description = "Мінімальна кількість нод у основному node group"
  type        = number
  default     = 1
}

variable "mng_max_size" {
  description = "Максимальна кількість нод у основному node group"
  type        = number
  default     = 4

  validation {
    condition     = var.mng_max_size >= var.mng_min_size
    error_message = "mng_max_size має бути >= mng_min_size."
  }
}

########################################
# Node Group - small (t3.small/micro)
########################################
variable "enable_small_node_group" {
  description = "Чи створювати другий node group"
  type        = bool
  default     = true
}

variable "small_instance_types" {
  description = "Список інстанс-типів для малого node group"
  type        = list(string)
  default     = ["t3.small"]

  validation {
    condition     = length(var.small_instance_types) > 0
    error_message = "small_instance_types не може бути порожнім."
  }
}

variable "small_mng_desired_size" {
  description = "Бажана кількість нод у малому node group"
  type        = number
  default     = 1
}

variable "small_mng_min_size" {
  description = "Мінімальна кількість нод у малому node group"
  type        = number
  default     = 0
}

variable "small_mng_max_size" {
  description = "Максимальна кількість нод у малому node group"
  type        = number
  default     = 2

  validation {
    condition     = var.small_mng_max_size >= var.small_mng_min_size
    error_message = "small_mng_max_size має бути >= small_mng_min_size."
  }
}
