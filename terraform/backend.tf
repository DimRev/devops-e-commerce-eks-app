terraform {
  backend "s3" {
    bucket         = "e-commerce-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "e-commerce-terraform-lock"
  }
}
