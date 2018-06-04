provider "aws" {
  region = "us-east-1"
}

module "data_stores_mysql" {
  source = "../../../modules/data-stores/mysql"

  database_name              = "dev-database"
  database_admin_username    = "superadmin"
  database_admin_password    = "${var.database_admin_password}"
  database_instance_type     = "t2.micro"
  database_allocated_storage = "10"
}
