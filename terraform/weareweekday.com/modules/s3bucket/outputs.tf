output "website_endpoint" { value = "${aws_s3_bucket.web_bucket.website_endpoint}" }
output "hosted_zone_id"  { value = "${aws_s3_bucket.web_bucket.hosted_zone_id}" }
