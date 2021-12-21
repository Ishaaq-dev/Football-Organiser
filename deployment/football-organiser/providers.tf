###############################################################################
# Provider for the module with default tags
###############################################################################
locals {
  bucket_name  = "${var.environment}-${var.project}-terraform-state"
  project_name = "${environment}-${project}-terraform-state-lock"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }
  }
  backend "s3" {
    bucket         = "development-football-organiser-terraform-state"
    region         = "eu-west-1"
    key            = "terraform.tfstate"
    dynamodb_table = "development-football-organiser-terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}
