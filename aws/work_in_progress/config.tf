terraform {
  backend "s3" {
    bucket  = "cocotton-terraform-up-and-running-state"
    key     = "work_in_progress/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}
