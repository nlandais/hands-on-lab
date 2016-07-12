# required vars
variable "env" {}
variable "vpc_id" {}
variable "office_range" {
  default = "23.239.224.0/24"
}

resource "aws_security_group" "weblab" {
  name = "${var.env}-weblab"
  description = "allows incoming connections for all the things we need in the lab"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "80"
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "22"
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.office_range}"]
  }

  ingress {
    from_port = "3389"
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["${var.office_range}"]
  }

  ingress {
    #winrm
    from_port = "5986"
    to_port = 5986
    protocol = "tcp"
    cidr_blocks = ["${var.office_range}"]
  }

  # allow incoming connections from this sec group
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  # allow all outgoing connects
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags {
    Env = "${var.env}-weblab"
    Environment = "${var.env}"
  }

}


output "id" {
  value = "${aws_security_group.weblab.id}"
}
