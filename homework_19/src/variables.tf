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

variable "ami_id" {
  description = "AMI ID for the EC2 instance (e.g., Amazon Linux 2)"
  default     = "ami-0c55b159cbfafe1f0" # Update this with a valid AMI for your region
}

variable "key_pair_name" {
  description = "The name of the key pair to associate with the EC2 Instance for SSH access."
  default     = "andrii-boiko-key"
}
