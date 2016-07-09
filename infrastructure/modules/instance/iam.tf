# With terraform 0.7[1] this can be abstracted into small re-usable modules (like modules/net).
# For now it's slightly noisy.
#
# [1]: https://github.com/hashicorp/terraform/pull/6858


resource "aws_iam_role" "role" {
    name = "${var.name}-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "${var.name}-instance-role" #
    roles = ["${aws_iam_role.role.name}"]
}

resource "aws_iam_role_policy" "policy" {
    name = "${var.name}-policy"
    role = "${aws_iam_role.role.id}"
    policy = "${var.policy}"
}

resource "aws_iam_role_policy" "deploy-pull" {
  name = "${var.name}-deploy-pull"
  role = "${aws_iam_role.role.id}"
  # TODO: insert the right name for the bucket.
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
              "arn:aws:s3:::lab-deployment-bucket/*",
              "arn:aws:s3:::lab-deployment-bucket"
            ]
        }
    ]
}
EOF
}
