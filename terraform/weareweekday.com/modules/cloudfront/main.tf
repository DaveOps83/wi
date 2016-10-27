resource "aws_cloudfront_origin_access_identity" "s3_access_identity" {
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.website_endpoint}"
    origin_id   = "web_bucket"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.s3_access_identity.cloudfront_access_identity_path}"
    }
  }
  enabled = true
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "web_bucket"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags {
      Name = "${var.jenkins_security_group_name}"
      Project = "${var.jenkins_security_group_name}"
      Environment = "${var.jenkins_security_group_tag_environment}"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
