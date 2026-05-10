output "website_bucket_name" {
  value = module.frontend.website_bucket_name
}

output "photos_bucket_name" {
  value = module.frontend.photos_bucket_name
}

output "cloudfront_distribution_id" {
  value = module.frontend.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  value = module.frontend.cloudfront_domain_name
}

output "analytics_endpoint" {
  value = module.analytics.analytics_endpoint
}

output "mapbox_access_token" {
  value = module.frontend.mapbox_access_token
  sensitive = true
}