variable "aws_access_key" {
  description = "AWS access key"
  #default = "AKI1231.."
}

variable "aws_secret_key" {
  description = "AWS secret key"
  #default = "SAB4gba4NB..."
}

variable "ansible_ami" {
  description = "AMI id for the ansible master"
  default     = "ami-ea26ce85"
}

variable "region" {
  description = "AWS region to launch this experiment in"
  default = "eu-central-1" #
}

variable "env" {
  description = "env name for this stack"
  default = "citritelab" # You should change this to not clash with other teams.
}


# Start doing stuff
provider "aws" {
  region          = "${var.region}"
  profile         = "default"
}

# Add your infrastructure here. It'll be fun - I promise.
# ...
