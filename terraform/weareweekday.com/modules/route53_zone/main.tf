resource "aws_route53_zone" "primary" {
  name = "weareweekday.com"
}

# resource "aws_route53_zone" "ci-staging" {
#   name = "ci-staging.weareweekday.com"

#   tags {
#     Environment = "staging"
#   }
# }

# resource "aws_route53_record" "ci-staging-ns" {
#     zone_id = "${aws_route53_zone.main.zone_id}"
#     name = "ci-staging.weareweekday.com"
#     type = "NS"
#     ttl = "30"
#     records = [
#         "${aws_route53_zone.ci-staging.name_servers.0}",
#         "${aws_route53_zone.ci-staging.name_servers.1}",
#         "${aws_route53_zone.ci-staging.name_servers.2}",
#         "${aws_route53_zone.ci-staging.name_servers.3}"
#     ]
# }