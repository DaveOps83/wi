resource "aws_elb" "tcp_elb" {
  name = "${var.tcp_elb_tag_name}"
  subnets = ["${split(",", var.tcp_elb_subnets)}"]
  instances = ["${split(",", var.tcp_elb_instances)}"]
  # cross_zone_load_balancing = "${var.elb_cross_zone}"
  idle_timeout = "${var.tcp_elb_idle_timeout}"
  connection_draining = "${var.tcp_elb_connection_draining}"
  connection_draining_timeout = "${var.tcp_elb_connection_draining_timeout}"
  security_groups = ["${var.tcp_elb_security_groups}"]
  listener {
    lb_port = 80
    lb_protocol = "tcp"
    # ssl_certificate_id = "${var.https_elb_ssl_cert_arn}"
    instance_port = "${var.tcp_elb_instance_port}"
    instance_protocol = "${var.tcp_elb_instance_protocol}"
  }
  health_check {
    healthy_threshold = "${var.tcp_elb_healthy_threshold}"
    unhealthy_threshold = "${var.tcp_elb_unhealthy_threshold}"
    timeout = "${var.tcp_elb_health_check_timeout}"
    # target = "${var.tcp_elb_instance_protocol}:${var/tcp_elb_instance_port}/${var.tcp_elb_health_check_target_path}"
    target = "${var.tcp_elb_instance_protocol}:${var.tcp_elb_instance_port}"
    interval = "${var.tcp_elb_health_check_interval}"
  }
  tags {
    Description = "${var.tcp_elb_tag_description}"
    Project = "${var.tcp_elb_tag_project}"
    Environment = "${var.tcp_elb_tag_environment}"
  }
}
