# Define environment and project-specific variables
variable "environment" {
  type    = string
  default = "PROD" # default value; you can override this per resource
}

variable "project" {
  type    = string
  default = "STEP_PROJECT_3" # default project; you can override this per resource
}

variable "owner" {
  type    = string
  default = "BOIKO" # default owner; you can override this per resource
}

# Define a function to create common tags with custom values
locals {
  # Function to generate unique Name tags for each resource
  dynamic_tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

# Define a reusable common_tags function that other files can call
variable "common_tags" {
  description = "Reusable tags that accept unique values per resource"
  type        = map(string)
  default     = {}
}

# Merge common tags with dynamic tags for use in each resource
locals {
  common_tags = merge(local.dynamic_tags, var.common_tags)
}
