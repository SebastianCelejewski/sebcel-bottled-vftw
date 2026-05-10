variable "environment" {
  type = string
}

variable "website_bucket_name" {
  type = string
}

variable "photos_bucket_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "aliases" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}