provider "aws" {
  region = "us-east-1"
}

module "data_stores_mysql" {
  source = "git::git@github.com:cocotton/terraform_up_and_running_modules.git//aws/data-stores/mysql?ref=v0.0.2"

  name              = "prdDatabase"
  admin_username    = "superadmin"
  admin_password    = "${var.database_admin_password}"
  instance_class    = "db.t2.micro"
  allocated_storage = "10"
}
