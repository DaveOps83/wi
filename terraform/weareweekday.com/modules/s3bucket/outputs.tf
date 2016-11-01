output "website_endpoint" { value = "${aws_s3_bucket.web_bucket.website_endpoint}" }
output "name" { value = "${aws_s3_bucket.web_bucket.id}" }
