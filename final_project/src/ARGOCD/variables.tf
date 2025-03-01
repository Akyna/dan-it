variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "boiko"
}

variable "domain_name" {
  description = "Base domain name for resources"
  type        = string
  default     = "devops5.test-danit.com"
}
