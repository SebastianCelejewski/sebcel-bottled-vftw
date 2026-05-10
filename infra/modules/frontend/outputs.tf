output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "website_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "photos_bucket_name" {
  value = aws_s3_bucket.photos.bucket
}

output "mapbox_access_token" {
  value = data.aws_ssm_parameter.mapbox_public_access_token.value
  sensitive = true
}