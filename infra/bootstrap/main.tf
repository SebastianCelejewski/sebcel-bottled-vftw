terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      application = "sebcel-bottled-vftw"
      environment = "bootstrap"
      owner = "Sebastian.Celejewski@wp.pl"
      managed-by = "terraform"
    }
  }
}

locals {
  org = "sebcel"
  app = "bottled-vftw"
  application = "${local.org}-${local.app}"
  terraform_state_bucket = "${local.application}-terraform-state"
  terraform_locks_table = "${local.application}-terraform-locks"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.terraform_state_bucket
  tags = { Name = local.terraform_state_bucket }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = local.terraform_locks_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = local.terraform_locks_table
  }
}