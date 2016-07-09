# base networking. We can always connect out and cross-connect internally.

# required vars
variable "env" {}
variable "vpc_id" {}

resource "aws_security_group" "base" {
  name = "${var.env}-base"
  description = "allows resources in this sec group to communicate to other resources within this sec group and to connect out"

  vpc_id = "${var.vpc_id}"

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
    Env = "${var.env}-base"
    Environment = "${var.env}"
  }

}

output "id" {
  value = "${aws_security_group.base.id}"
}
