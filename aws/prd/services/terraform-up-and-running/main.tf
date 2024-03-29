provider "aws" {
  region = "us-east-1"
}

module "terraform_up_and_running" {
  source = "git::git@github.com:cocotton/terraform_up_and_running_modules.git//aws/services/terraform-up-and-running?ref=v0.1.0"

  cluster_name                 = "prd"
  cluster_min_size             = 4
  cluster_max_size             = 10
  instance_type                = "t2.micro"
  database_remote_state_bucket = "cocotton-terraform-up-and-running-state"
  database_remote_state_key    = "prd/data-stores/mysql/terraform.tfstate"
  enable_autoscaling           = true
}
