terraform {
  backend "s3" {
    bucket  = "cocotton-terraform-up-and-running-state"
    key     = "global/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = "true"
    dynamodb_table = "terraform-state-lock"
  }
}
