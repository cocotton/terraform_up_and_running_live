terraform {
  backend "s3" {
    bucket         = "cocotton-terraform-up-and-running-state"
    key            = "prd/services/terraform-up-and-running/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "terraform-state-lock"
  }
}
