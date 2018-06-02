provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "example_database" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "exampleDatabase"
  username          = "exampleadmin"
  password          = "${var.database_password}"
}
