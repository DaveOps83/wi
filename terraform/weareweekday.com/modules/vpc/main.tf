resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "${var.vpc_name_tag}"
        Description = "${var.vpc_description_tag}"
        Project = "${var.vpc_project_tag}"
        Environment = "${var.vpc_environment_tag}"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "${var.vpc_name_tag}"
        Description = "${var.vpc_description_tag}"
        Project = "${var.vpc_name_tag}"
        Environment = "${var.vpc_environment_tag}"
    }
}

resource "aws_subnet" "primary_private" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.vpc_primary_private_cidr_block}"
    availability_zone = "${var.vpc_primary_az}"
    tags {
        Name = "${var.vpc_name_tag}-primary-private"
        Description = "${var.vpc_description_tag}"
        Project = "${var.vpc_project_tag}"
        Environment = "${var.vpc_environment_tag}"
    }
}

resource "aws_route_table" "primary_private" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.primary_nat_gateway.id}"
    }    
    tags {
        Name = "${var.vpc_name_tag}-primary-private"
        Description = "${var.vpc_description_tag}"
        Project = "${var.vpc_project_tag}"
        Environment = "${var.vpc_environment_tag}"
    }
}

resource "aws_route_table_association" "primary_private" {
    subnet_id = "${aws_subnet.primary_private.id}"
    route_table_id = "${aws_route_table.primary_private.id}"
}

resource "aws_subnet" "primary_public" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.vpc_primary_public_cidr_block}"
    availability_zone = "${var.vpc_primary_az}"
    tags {
        Name = "${var.vpc_name_tag}-primary-public"
        Description = "${var.vpc_description_tag}"
        Project = "${var.vpc_name_tag}"
        Environment = "${var.vpc_environment_tag}"
    }
}

resource "aws_route_table" "primary_public" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internet_gateway.id}"
    }
    tags {
        Name = "${var.vpc_name_tag}-primary-public"
        Description = "${var.vpc_description_tag}"
        Project = "${var.vpc_name_tag}"
        Environment = "${var.vpc_environment_tag}"
    }
}

resource "aws_route_table_association" "primary_public" {
    subnet_id = "${aws_subnet.primary_public.id}"
    route_table_id = "${aws_route_table.primary_public.id}"
}

resource "aws_eip" "primary_nat_eip" {
    vpc = true
}

resource "aws_nat_gateway" "primary_nat_gateway" {
    allocation_id = "${aws_eip.primary_nat_eip.id}"
    subnet_id = "${aws_subnet.primary_public.id}"
    depends_on = ["aws_internet_gateway.internet_gateway"]
}
