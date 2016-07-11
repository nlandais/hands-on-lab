resource "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh.tmpl")}"
  count    = "${var.servers}"

  vars {
    name             = "${var.name}${count.index}" # might be ignored by bootstraper
  }
}

resource "aws_instance" "server" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  count         = "${var.servers}"
  ebs_optimized = "${var.ebs_optimized}"

  # dependencies
  depends_on = ["aws_iam_instance_profile.instance_profile"]

  # user data
  user_data = "${element(template_file.user_data.*.rendered, count.index)}"
  key_name  = "admin"
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.vol_size}"
  }
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"


  # tags
  tags {
    Name        = "${var.name}${count.index}.${var.env}"
  }

  vpc_security_group_ids = ["${split(",", var.sec_group_ids)}"]
  subnet_id              = "${element(split(",", var.subnet_ids), count.index)}"
}

# Cannot be CNAME to public / private DNS name since private DNS cannot be looked up from the
# public side (ie - it's useless).
# TODO: move to private hosted zone in r53 and dual publish both internal and external IP.
resource "aws_route53_record" "server" {
  zone_id = "${var.r53_zone_id}"
  name = "${var.name}${count.index}"
  type = "A"
  ttl = "300"
  records = ["${element(aws_instance.server.*.private_ip, count.index)}"]
  count = "${var.servers}"
}

output "public_ips" {
  value = "${join(",", aws_instance.server.*.public_ip)}"
}

output "private_ips" {
  value = "${join(",", aws_instance.server.*.private_ips)}"
}

output "instance_ids" {
  value = "${join(",", aws_instance.server.*.id)}"
}

output "names" {
  value = "${join(",", aws_route53_record.server.*.name)}"
}

output "azs" {
  value = "${join(",", aws_instance.server.*.availability_zone)}"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.instance_profile.id}"
}

output "iam_role" {
  value = "${aws_iam_role.role.id}"
}
