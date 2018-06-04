output "iam_users_arn" {
  value = ["${aws_iam_user.example_iam.*.arn}"]
}
