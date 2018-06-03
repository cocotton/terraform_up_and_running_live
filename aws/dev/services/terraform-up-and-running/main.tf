provider "aws" {
  region = "us-east-1"
}

module "terraform_up_and_running" {
  source = "../../../modules/services/terraform-up-and-running"
}
