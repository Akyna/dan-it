variable "aws_region" {
  default = "eu-central-1"
}

variable "vpc_cidr_block" {
  default = "10.42.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.42.0.0/17"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair_name" {
  description = "The name of the key pair to associate with the EC2 Instance for SSH access."
  default     = "andrii-boiko-key"
}
