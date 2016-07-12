// Required vars
variable "env" {
  description = "Environment"
}

variable "region" {
  description = "the region this group of instances should be in"
}

variable "subnet_ids" {
  description = "list of subnets to bind to"
}

variable "name" {
  description = "Name of the server"
}

variable "sec_group_ids" {
  description = "security groups ids"
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "
}

variable "r53_zone_id" {
  description = "The zone ID to register this host under"
}

variable "policy" {
  description = "iam role"
  # not good for prod. Needed for to simplify setup.
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

variable "key_pair" {
  default = "DevOps-lab"
  description = "AWS SSH key to inject"
}

variable "servers" {
  default = "1"
  description = "The number of instances to launch"
}

variable "instance_type" {
  default = "t2.micro"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "ebs_optimized" {
  default = "false"
  description = "Is the instances EBS optimized or not"
}

variable "vol_size" {
  default = 40
}
