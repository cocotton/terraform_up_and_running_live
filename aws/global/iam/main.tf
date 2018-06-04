provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example_iam_users" {
  count = "${length(var.iam_users)}"
  name  = "${element(var.iam_users, count.index)}"
}

data "aws_iam_policy_document" "ec2_read_only" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_read_only" {
  name   = "ec2-read-only"
  policy = "${data.aws_iam_policy_document.ec2_read_only.json}"
}

resource "aws_iam_user_policy_attachment" "ec2_read_only_access" {
  count      = "${length(var.iam_users)}"
  user       = "${element(aws_iam_user.example_iam_users.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.ec2_read_only.arn}"
}
