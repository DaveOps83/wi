# resource "aws_route53_record" "www" {
#   zone_id = "${var.primary_zone_id}"
#   name = "staging.weareweekday.com"
#   type = "A"

#   alias {
#     name = "${var.website_bucket_name}"
#     zone_id = "${var.website_zone_id}"
#     evaluate_target_health = false
#   }
# }

resource "aws_route53_record" "staging" {
   zone_id = "${var.hosted_zone_id}"
   name = "staging.origin.weareweekday.com"
   type = "A"
   # ttl = "300"
   records = ["${var.website_endpoint}"]
}
