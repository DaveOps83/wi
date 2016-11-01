/*

The zone weareweekday.com has already been provisioned in AWS and is in use by other stacks.
To work around this the hosted_zone_id of the existing zone has been set in the outputs.tf file for this module.

*/

resource "aws_route53_zone" "environments" {
  name = "${var.dns_env}.${var.dns_website_domain}"
}
