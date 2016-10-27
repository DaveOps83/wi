variable "aws_target_env" {
  description = "Target AWS environment abbreviation in LOWERCASE - [staging/prod]"
}

variable "stack_name" {
  description = "Name tag value to be used for all resources within the stack."
  default = "weareweekday.com"
}
variable "stack_description" {
  description = "Description tag value to be used for all resources within the stack."
  default = "weareweekday.com stack"
}
variable "region" {
    description = "AWS region in which to launch stack."
    default = {
        staging = "eu-west-1"
        prod    = "eu-west-1"
    }
}
variable "primary_az" {
    description = "Primary AWS availability zone in which to launch stack."
    default = {
        staging = "eu-west-1a"
        prod    = "eu-west-1a"
    }
}
variable "jenkins_ami" {
    description = "AWS AMI to use when launching Jenkins instances in our chosen regions."
    default = {
        eu-west-1 = "ami-d41d58a7"
    }
}
variable "jenkins_instance_type" {
    description = "AWS instance type to use when launching Jenkins instances."
    default = {
        staging = "t2.small"
        prod = "t2.small"
    }
}
variable "jenkins_key_pair" {
    description = "AWS key pair to use when launching Jenkins instances."
    default = {
        staging = "weekday"
        prod = "weekday"
    }
}
variable "bastion_ami" {
    description = "AWS AMI to use when launching bastion instances in our chosen regions."
    default = {
        eu-west-1 = "ami-d41d58a7"
    }
}
variable "bastion_key_pair" {
  description = "AWS key pair to use when launching the bastion instance."
  default = {
        staging = "weekday"
        prod = "weekday"
  }
}
