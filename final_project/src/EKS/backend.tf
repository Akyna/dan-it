terraform {
  backend "s3" {
    bucket  = "terraform-state-danit-devops5"
    key     = "boiko/eks_final_project.tfstate"
    encrypt = true
    # Params taken from -backend-config when terraform init
    # region =
    # profile =
  }
}

