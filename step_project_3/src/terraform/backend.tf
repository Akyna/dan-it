terraform {
  backend "s3" {
    bucket = "boiko-step-project-3"
    key    = "iac.tfstate"
    region = "eu-central-1"
  }
}
