provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-6a003c0f"
  instance_type = "t2.micro"
}
