provider "aws" {
  region = "us-east-1"
}

module "terraform_up_and_running" {
  source = "git::git@github.com:cocotton/terraform_up_and_running_modules.git//aws/services/terraform-up-and-running?ref=v0.0.2"

  cluster_name                 = "prd"
  cluster_min_size             = 4
  cluster_max_size             = 10
  instance_type                = "t2.micro"
  database_remote_state_bucket = "cocotton-terraform-up-and-running-state"
  database_remote_state_key    = "prd/data-stores/mysql/terraform.tfstate"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = "${module.terraform_up_and_running.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = "${module.terraform_up_and_running.asg_name}"
}
