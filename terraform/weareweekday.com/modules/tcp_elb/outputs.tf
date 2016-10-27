output "dns_name" { value = "${aws_elb.tcp_elb.dns_name}" }
output "zone_id"  { value = "${aws_elb.tcp_elb.zone_id}" }
