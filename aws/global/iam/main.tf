provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example_iam" {
  count = "${length(var.iam_users)}"
  name  = "${element(var.iam_users, count.index)}"
}
