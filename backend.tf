terraform {
  backend "s3" {
    bucket         = "tf-states-876594438088"
    key            = "root/root.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
