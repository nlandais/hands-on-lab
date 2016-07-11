# required vars
variable "env" {}
variable "vpc_id" {}

resource "aws_security_group" "ssh" {
  name = "${var.env}-ssh"
  description = "allows global SSH to resources inside this "

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags {
    Env = "${var.env}-ssh"
    Environment = "${var.env}"
  }

}

output "id" {
  value = "${aws_security_group.ssh.id}"
}
