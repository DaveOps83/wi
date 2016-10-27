provider "aws" {
  region = "${lookup(var.region, var.aws_target_env)}"
}

module "vpc" {
    source = "modules/vpc"
    vpc_cidr_block = "10.0.0.0/25"
    vpc_primary_private_cidr_block = "10.0.0.0/27"
    vpc_primary_public_cidr_block = "10.0.0.32/27"
    vpc_primary_az = "${lookup(var.primary_az, var.aws_target_env)}"
    vpc_name_tag = "${var.stack_name}"
    vpc_description_tag = "${var.stack_description}"
    vpc_project_tag = "${var.stack_name}"
    vpc_environment_tag = "${var.aws_target_env}"
}

module "bastion_security_group" {
    source = "modules/bastion_security_group"
    bastion_security_group_vpc_id = "${module.vpc.id}"
    # bastion_security_group_ssh_source_range = "${var.dc_egress_range}"
    bastion_security_group_jenkins_security_group = "${module.jenkins_security_group.id}"
    bastion_security_group_name = "${var.stack_name}-bastion"
    bastion_security_group_description = "${var.stack_description}"
    bastion_security_group_tag_project = "${var.stack_name}"
    bastion_security_group_tag_environment = "${var.aws_target_env}"
}

module "jenkins_security_group" {
    source = "modules/jenkins_security_group"
    jenkins_security_group_vpc_id = "${module.vpc.id}"
    jenkins_security_group_bastion_security_group = "${module.bastion_security_group.id}"
    jenkins_security_group_name = "${var.stack_name}-jenkins"
    jenkins_security_group_description = "${var.stack_description}"
    jenkins_security_group_tag_project = "${var.stack_name}"
    jenkins_security_group_tag_environment = "${var.aws_target_env}"
}

module "jenkins_instance" {
    source = "modules/instance"
    instance_ami = "${lookup(var.jenkins_ami, lookup(var.region, var.aws_target_env))}"
    instance_type = "${lookup(var.jenkins_instance_type, var.aws_target_env)}"
    instance_key_pair = "${lookup(var.jenkins_key_pair, var.aws_target_env)}"
    instance_subnet = "${module.vpc.primary_private_subnet}"
    instance_associate_public_ip_address = "false"

    instance_security_group = "${module.jenkins_security_group.id}"

    instance_monitoring = "true"
    instance_disable_api_termination = "false"
    instance_tag_name = "${var.stack_name}-jenkins-ci"
    instance_tag_description = "${var.stack_description}"
    instance_tag_project = "${var.stack_name}"
    instance_tag_environment = "${var.aws_target_env}"
}

module "bastion_instance" {
    source = "modules/instance"
    instance_ami = "${lookup(var.bastion_ami, lookup(var.region, var.aws_target_env))}"
    instance_type = "t2.nano"
    instance_key_pair = "${lookup(var.bastion_key_pair, var.aws_target_env)}"
    instance_subnet = "${module.vpc.primary_public_subnet}"
    instance_associate_public_ip_address = "true"
    instance_security_group = "${module.bastion_security_group.id}"
    # instance_profile = "${module.bastion_instance_profile.name}"
    instance_monitoring = "false"
    instance_disable_api_termination = "false"
    # instance_user_data = "${module.bastion_user_data.user_data}"
    instance_tag_name = "${var.stack_name}-bastion"
    instance_tag_description = "${var.stack_description}"
    instance_tag_project = "${var.stack_name}"
    instance_tag_environment = "${var.aws_target_env}"
}

module "jenkins_elb_security_group" {
    source = "modules/jenkins_elb_security_group"
    jenkins_elb_security_group_vpc_id = "${module.vpc.id}"
    jenkins_elb_security_group_jenkins_security_group = "${module.jenkins_security_group.id}"
    jenkins_elb_security_group_name = "${var.stack_name}-jenkins-elb"
    jenkins_elb_security_group_description = "${var.stack_description}"
    jenkins_elb_security_group_tag_project = "${var.stack_name}"
    jenkins_elb_security_group_tag_environment = "${var.aws_target_env}"
}

module "jenkins_elb" {
    source = "modules/tcp_elb"
    tcp_elb_subnets = "${module.vpc.primary_public_subnet}"
    # tcp_elb_cross_zone = "true"
    tcp_elb_idle_timeout = "30"
    tcp_elb_connection_draining = "true"
    tcp_elb_connection_draining_timeout = "30"
    tcp_elb_security_groups = "${module.jenkins_elb_security_group.id}"
    # tcp_elb_ssl_cert_arn = "${lookup(var.ssl_cert, var.aws_target_env)}"
    tcp_elb_instances = "${module.jenkins_instance.id}"
    tcp_elb_instance_port = "8080"
    tcp_elb_instance_protocol = "TCP"
    tcp_elb_healthy_threshold = "3"
    tcp_elb_unhealthy_threshold = "3"
    tcp_elb_health_check_timeout = "30"
    # tcp_elb_health_check_target_path = "health-check"
    tcp_elb_health_check_interval = "60"
    # tcp_elb_tag_name = "${var.stack_name}-jenkins-ci"
    tcp_elb_tag_name = "weareweekdaydotcom-jenkins-ci"
    tcp_elb_tag_description = "${var.stack_description}"
    tcp_elb_tag_project = "${var.stack_name}"
    tcp_elb_tag_environment = "${var.aws_target_env}"
}

module "web_bucket" {
    source = "modules/s3bucket"
}

module "cloudfront" {
    source = "modules/cloudfront"
    website_endpoint =  "${module.web_bucket.website_endpoint}"
}


# TODO : as Terraform is not authorised to access Route 53, this have to be done manually

# module "route53_zone" {
#     source = "modules/route53_zone"

# }

# * aws_route53_record.www: missing dependency: aws_route53_zone.primary
# * aws_route53_record.www: missing dependency: aws_s3_bucket.staticwebsite
# * aws_route53_record.www: missing dependency: aws_s3_bucket.staticwebsite

# module "route53_record" {
#     source = "modules/route53_record"
#     website_endpoint =  "${module.web_bucket.website_endpoint}"
#     hosted_zone_id  = "${module.web_bucket.hosted_zone_id}"
# }
