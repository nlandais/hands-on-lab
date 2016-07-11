# This modules creates ${az_count} private and ${az_count} public subnets on a given VPC.
# It also create gateways (internet gw, nat gw and matching route tables) that allows instances to hit the internet


# required stuff
variable "env" {
  description = "the podio environment stack name"
}


variable "vpc_cidr" {
  description = "The base network range covering the entire VPC"
}

variable "private_cidr_base" {
  description = "CIDR range for private subnets. Must be a subset of the overall VPC range. Must not overlap with public_cidr_base"
}

variable "public_cidr_base" {
  description = "CIDR range for public subnets. Must be a subset of the overall VPC range. Must not overlap with private_cidr_base."
}
variable "dnsbase" {
  description = "DNS base name for the private hosted zones that will be created and associated with this VPC"
}


# optional stuff
variable "region" {
  description = "AWS to spin up the VPC in"
  default = "us-east-1"
}


variable "subnet_bits" {
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet_iprange_newbits_netnum_
  description = "number of bits to on top of the {public,private}_cidr_base. 2^{subnet_bits} must be larger than az_count."
  default = 3
}

# HACK: needed until terraform 0.7 is out
# https://github.com/hashicorp/terraform/pull/6598 ->
# https://github.com/hashicorp/terraform/issues/4169 ->
# https://github.com/hashicorp/terraform/issues/3888
variable "az_count" {
  description = "number of zones in the region to distribute over"
  default = 3
}

module "az" {
  source  = "../aws_region"

  region = "${var.region}"
}

# here come the resources
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.env}"
  }
}


# allow us to address hosts by short names. Neato.
resource "aws_route53_zone" "apex" {
  name = "${var.dnsbase}"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_vpc_dhcp_options" "main_opts" {
  domain_name = "${var.dnsbase}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags {
    Name = "${var.env}-dhcp-opts"
  }
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main_opts.id}"
}



# now we create public and private subnets for each AZ.

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.public_cidr_base, var.subnet_bits, count.index)}"
  # create a public subnet for each zone
  availability_zone       = "${element(split(",", module.az.list_all), count.index)}"
  count                   = "${var.az_count}"
  map_public_ip_on_launch = true

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.env}-public-subnet-${element(split(",", module.az.list_all), count.index)}"
  }
}

resource "aws_subnet" "private" {
  vpc_id              = "${aws_vpc.main.id}"
  cidr_block          = "${cidrsubnet(var.private_cidr_base, var.subnet_bits, count.index)}"
  # create a private subnet for each zone
  availability_zone   = "${element(split(",", module.az.list_all), count.index)}"
  count               = "${var.az_count}"


  lifecycle {
    create_before_destroy = true
  }


  tags {
    Name = "${var.env}-private-subnet-${element(split(",", module.az.list_all), count.index)}"
  }
}


# routes for outgoing traffic. (This allows hosts to talk to the internet)

# create a private route table for each zone. We need a table for each zone since NAT gateways are tied to zones.
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"
  count  = "${var.az_count}"

  tags {
    Name = "${var.env}-private-${element(split(",", module.az.list_all), count.index)}"
  }
}

# create a route pr zone to the NAT gateway (defined later)
resource "aws_route" "to_nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  count                  = "${var.az_count}"

  depends_on             = ["aws_route_table.private"]
}

# now hook the route and the route tables back togehters
resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${var.az_count}"
}

# create the route table for the public network.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  # We can define the route(s) inline since it'll be the same irregardless of zone
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.env}-public"
  }
}


resource "aws_route_table_association" "public" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


# Gateways (NAT and not) and endpoints


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
}

# nat gateways - one pr zone. So data can flow _from_ the private network _to_ the Internet.
resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.az_count}"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  count         = "${var.az_count}"
}

resource "aws_vpc_endpoint" "s3endpoint" {
  vpc_id = "${aws_vpc.main.id}"
  route_table_ids = ["${aws_route_table.private.*.id}", "${aws_route_table.public.id}"]
  service_name = "com.amazonaws.${var.region}.s3"
}

# People consuming this module will need the Subnet IDs and the VPC id.
output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "private_zone_id"  {
  value = "${aws_route53_zone.apex.zone_id}"
}
