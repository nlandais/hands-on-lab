# required vars
variable "env" {}
variable "vpc_id" {}

resource "aws_security_group" "rdp" {
  name = "${var.env}-rdp"
  description = "allows global access to RDP (3389) for resources inside this SG"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 3389
    to_port = 3390
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags {
    Env = "${var.env}-ssh"
    Environment = "${var.env}"
  }

}

output "id" {
  value = "${aws_security_group.rdp.id}"
}
