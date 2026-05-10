terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      application = "sebcel-bottled-vftw"
      environment = var.environment
      owner = "Sebastian.Celejewski@wp.pl"
      managed-by = "terraform"
    }
  }
}

module "frontend" {
  source = "../../modules/frontend"
  environment = var.environment
  website_bucket_name = local.website_bucket_name
  photos_bucket_name = local.photos_bucket_name
  domain_name = var.domain_name
  aliases = var.aliases
  acm_certificate_arn = var.acm_certificate_arn
  web_acl_id = var.web_acl_id
}

module "analytics" {
  source = "../../modules/analytics"
  environment = var.environment
}