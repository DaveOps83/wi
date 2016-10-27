output "VPC - CIDR block" { value = "${module.vpc.cidr_block}" }
output "VPC - ID" { value = "${module.vpc.id}" }
output "VPC - Primary Private Subnet Route Table ID" { value = "${module.vpc.primary_private_route_table}" }
output "VPC - Primary Private Subnet CIDR block" { value = "${module.vpc.primary_private_cidr_block}" }
output "VPC - Primary NAT Gateway Public IP" { value = "${module.vpc.primary_nat_gateway_eip}" }
output "SSH - Bastion" { value = "ssh -i ${module.bastion_instance.key_name}.pem ec2-user@${module.bastion_instance.public_ip}" }

