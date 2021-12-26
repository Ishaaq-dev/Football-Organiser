provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "development-football-organiser-terraform-state"

  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "development-football-organiser-terraform-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
