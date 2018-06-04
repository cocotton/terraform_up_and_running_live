resource "aws_db_instance" "example_database" {
  engine              = "mysql"
  allocated_storage   = "${var.database_allocated_storage}"
  instance_class      = "${var.database_instance_type}"
  name                = "${var.database_name}"
  username            = "${var.database_admin_username}"
  password            = "${var.database_admin_password}"
  skip_final_snapshot = "true"
}
