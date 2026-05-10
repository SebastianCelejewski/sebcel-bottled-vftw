output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "website_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "photos_bucket_name" {
  value = aws_s3_bucket.photos.bucket
}