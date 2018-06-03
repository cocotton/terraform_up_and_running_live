provider "aws" {
  region = "us-east-1"
}

module "terraform_up_and_running" {
  source = "../../../modules/services/terraform-up-and-running"

  cluster_name                 = "dev"
  database_remote_state_bucket = "cocotton-terraform-up-and-running-state"
  database_remote_state_key    = "dev/data-stores/mysql/terraform.tfstate"
}
