# required vars
variable "env" {}
variable "vpc_id" {}

resource "aws_security_group" "http" {
  name = "${var.env}-http"
  description = "allows incoming HTTP connections"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags {
    Env = "${var.env}-http"
    Environment = "${var.env}"
  }

}

output "id" {
  value = "${aws_security_group.http.id}"
}
