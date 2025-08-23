output "s3_bucket" {
  description = "S3 bucket name для state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table" {
  description = "Назва DynamoDB таблиці для lock"
  value       = aws_dynamodb_table.terraform_locks.name
}
