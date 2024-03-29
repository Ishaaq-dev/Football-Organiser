terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }
    atlas = {
      source = "ariga/atlas"
      version = "~> 0.1.0"
    }
  }
  backend "s3" {
    bucket         = "personal-football-organiser-terraform-state"
    region         = "eu-west-1"
    dynamodb_table = "personal-football-organiser-terraform-state-lock"
    encrypt        = true
    key            = "one_time/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}
