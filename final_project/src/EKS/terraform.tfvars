# AWS account config
region = "eu-central-1"

# General for all infrastructure
# This is the name prefix for all infra components
name = "boiko"

vpc_id      = "vpc-0cc14956f511752ef"
subnets_ids = ["subnet-008f4682821ea3f6b", "subnet-08fe5b66ae7092b0d", "subnet-05ac9cbd8be5a9615"]

tags = {
  Environment = "test-studen1"
  TfControl   = "true"
}

zone_name = "devops5.test-danit.com"
