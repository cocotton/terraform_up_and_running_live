provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "all" {}

data "terraform_remote_state" "example_database" {
  backend = "s3"

  config {
    bucket = "cocotton-terraform-up-and-running-state"
    key    = "dev/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}

data "template_file" "user_data" {
  template = "${file("user-data.sh")}"

  vars {
    server_port      = "${var.server_port}"
    database_address = "${data.terraform_remote_state.example_database.address}"
    database_port    = "${data.terraform_remote_state.example_database.port}"
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-a4dc46db"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.example_instance.id}"]

  user_data = "FILLEMEUP"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_instance" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

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
  security_groups    = ["${aws_security_group.example_elb.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "example_instance" {
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

resource "aws_security_group" "example_elb" {
  name = "example-elb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
