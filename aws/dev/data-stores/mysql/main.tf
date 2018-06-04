provider "aws" {
  region = "us-east-1"
}

module "data_stores_mysql" {
  source = "../../../modules/data-stores/mysql"

  name              = "dev-database"
  admin_username    = "superadmin"
  admin_password    = "${var.database_admin_password}"
  instance_class    = "db.t2.micro"
  allocated_storage = "10"
}
