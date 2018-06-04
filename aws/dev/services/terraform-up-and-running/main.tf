provider "aws" {
  region = "us-east-1"
}

module "terraform_up_and_running" {
  source = "../../../modules/services/terraform-up-and-running"

  cluster_name                 = "dev"
  cluster_min_size             = 2
  cluster_max_size             = 10
  instance_type                = "t2.micro"
  database_remote_state_bucket = "cocotton-terraform-up-and-running-state"
  database_remote_state_key    = "dev/data-stores/mysql/terraform.tfstate"
  skip_final_snapshot          = true
}
