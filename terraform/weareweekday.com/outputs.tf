  output "VPC - Primary NAT Gateway Public IP" { value = "${module.vpc.primary_nat_gateway_eip}" }
#output "SSH - Bastion" { value = "ssh -i ${module.bastion_instance.key_name}.pem ec2-user@${module.bastion_instance.public_ip}" }
