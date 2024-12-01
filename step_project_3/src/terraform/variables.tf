variable "aws_region" {
  default = "eu-central-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "spot_instance_type" {
  default = "t2.micro"
}

variable "key_pair_name" {
  description = "The name of the key pair to associate with the EC2 Instance for SSH access."
  default     = "andrii-boiko-key"
}

variable "ssh_public_key" {
  default = "public_key"
}

# Slave section
variable "pvt_key" {
  description = "Private key location"
}
