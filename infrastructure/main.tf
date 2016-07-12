# Complete the infrastructure definitions below. It'll be fun - I promise.

# To test: `terraform plan`
# To apply: `terraform apply`


variable "aws_access_key" {
  description = "The access key handed out for the lab"
  #default = "AKI123..."
}

variable "aws_secret_key" {
  description = "The secret key handed out for the lab"
  #default = "SAB4gba4NB..."
}

variable "region" {
  description = "AWS region to launch this lab stack in."
  default = "us-east-1"
}

variable "env" {
  description = "Name for this lab stack. Should be unique."
}


variable "ansible_ami" {
  description = "AMI id for the ansible master"
  # use like
  #    ami = "${lookup(var.ansible_ami, var.region)}"
  default = {
    "us-east-1" = "ami-923cbc85"
    "us-west-1" = "ami-2589cf45"
    "us-west-2" = "ami-8f68abef"
  }
}

# Start doing stuff
provider "aws" {
  region          = "${var.region}"
  profile         = "default"
  access_key      = "${var.aws_access_key}"
  secret_key      = "${var.aws_secret_key}"
}



# define the main "datacenter"
module "dc" {
  source            = "modules/vpc"
## These are required parameters.
#  env               = "${var.env}"
#  dnsbase           = "${var.env}"
#  region            = "${var.region}"

  # Come up with a good network layout.
  vpc_cidr          = "10.9.0.0/22x" # why is this invalid?
  private_cidr_base = "10.9.8.0/24x"
  public_cidr_base  = "10.9.7.0/24x"
  subnet_bits       = 2 # 24 - 22 = 2
}

module "sg_weblab" {
  source = "modules/net/weblab"
  ## Find and fill in the missing params.
}

module "ansible" {
  source        = "modules/instance"
  # name          = ""  # name of the instance(s) launched
  env           = "${var.env}"
  region        = "${var.region}"
  r53_zone_id   = "${module.dc.private_zone_id}"
  sec_group_ids = "${module.sg_weblab.id}"

  ## more required params
  # subnet_ids    = "should be the public subnet ID from module dc"
  # ami           = "use the lookup method from https://www.terraform.io/docs/configuration/variables.html"
}
