provider "aws" {
  region = "us-east-1"
}

variable "server_port" {
  description = "The port the servier will use for HTTP requests"
  default     = 8080
}

resource "aws_instance" "example" {
  ami                    = "ami-a4dc46db"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.example.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello baby" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "example" {
  name = "example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
