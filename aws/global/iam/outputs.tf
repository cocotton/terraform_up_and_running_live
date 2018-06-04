output "iam_users_arn" {
  value = ["${aws_iam_user.example_iam_users.*.arn}"]
}
