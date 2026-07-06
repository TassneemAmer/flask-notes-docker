provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "flask-notes-docker"
      Environment = "Terraform"
      ManagedBy   = "Terraform"
    }
  }
}