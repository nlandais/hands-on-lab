# required vars
variable "env" {}
variable "vpc_id" {}

resource "aws_security_group" "https" {
  name = "${var.env}-https"
  description = "allows incoming HTTPS connections"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags {
    Env = "${var.env}-https"
    Environment = "${var.env}"
  }

}

output "id" {
  value = "${aws_security_group.https.id}"
}
