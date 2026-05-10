locals {
  org = "sebcel"
  app = "bottled-vftw"
  application = "${local.org}-${local.app}"
  website_component = "website"
  photos_component = "photos"
  website_bucket_name = "${local.application}-${local.website_component}-bucket-${var.environment}"
  photos_bucket_name = "${local.application}-${local.photos_component}-bucket-${var.environment}"
}