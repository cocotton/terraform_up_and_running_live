data "aws_availability_zones" "all" {}

data "terraform_remote_state" "example_database" {
  backend = "s3"

  config {
    bucket = "${var.database_remote_state_bucket}"
    key    = "${var.database_remote_state_key}"

    //    bucket = "cocotton-terraform-up-and-running-state"
    //    key    = "dev/data-stores/mysql/terraform.tfstate"
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
  name            = "${var.cluster_name}-launch-configuration"
  image_id        = "ami-a4dc46db"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.example_instance.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_instance" {
  name                 = "${var.cluster_name}-autoscaling-group"
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-autoscaling-group"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name               = "${var.cluster_name}-elastic-loadbalancer"
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
  name = "${var.cluster_name}-instance-security-group"

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
  name = "${var.cluster_name}-elb-security-group"

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
