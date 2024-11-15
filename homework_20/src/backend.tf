provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-danit-devops5"
    key    = "boiko/iac_hw20.tfstate"
    region = "eu-central-1"
  }
}
