variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "Назва S3 bucket для Terraform state (має бути унікальна глобально)"
  type        = string
  default     = "tf-states-876594438088"
}

variable "dynamodb_table_name" {
  description = "Назва DynamoDB таблиці для lock"
  type        = string
  default     = "terraform-locks"
}

variable "environment" {
  description = "Назва середовища (dev/stage/prod)"
  type        = string
  default     = "dev"
}
