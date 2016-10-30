resource "aws_route53_record" "jenkins" {
  zone_id = "${var.dns_hosted_zone_id}"
  name = "ci.${var.dns_env}.${var.dns_website_domain}"
  type = "CNAME"
  ttl = "300"
  records = ["${var.dns_jenkins_elb}"]
}

resource "aws_route53_record" "web_bucket" {
  zone_id = "${var.dns_hosted_zone_id}"
  name = "origin.${var.dns_env}.${var.dns_website_domain}"
  type = "CNAME"
  ttl = "300"
  records = ["${var.dns_s3_bucket}"]
}

resource "aws_route53_record" "cloudfront" {
  zone_id = "${var.dns_hosted_zone_id}"
  name = "cdn.${var.dns_env}.${var.dns_website_domain}"
  type = "CNAME"
  ttl = "300"
  records = ["${var.dns_cloudfront}"]
}
