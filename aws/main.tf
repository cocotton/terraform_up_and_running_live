provider "aws" {
  region = "us-east-1"
}

variable "server_port" {
  description = "The port the servier will use for HTTP requests"
  default     = 8080
}

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-a4dc46db"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.example.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello baby" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "asg-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name               = "elb-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }
}
