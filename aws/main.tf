provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-a4dc46db"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }
}
