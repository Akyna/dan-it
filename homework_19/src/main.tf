provider "aws" {
  region = var.aws_region
}
# We can create it on the fly
# # Define Key Pair for Instances
# resource "aws_key_pair" "andrii_boiko_key" {
#   key_name = "andrii-boiko-key"
#   public_key = file("~/.ssh/andrii-boiko-key.pub")
# }

# Create VPC
resource "aws_vpc" "boiko_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-VPC-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Create Internet Gateway for Public Access
resource "aws_internet_gateway" "boiko_igw" {
  vpc_id = aws_vpc.boiko_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-IGW-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Public Subnet
resource "aws_subnet" "boiko_public_subnet" {
  vpc_id                  = aws_vpc.boiko_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-SUBNET-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Private Subnet
resource "aws_subnet" "boiko_private_subnet" {
  vpc_id     = aws_vpc.boiko_vpc.id
  cidr_block = var.private_subnet_cidr_block

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-SUBNET-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "boiko_nat_eip" {
  # vpc = true
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-NAT-EIP-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Create NAT Gateway in the Public Subnet
resource "aws_nat_gateway" "boiko_nat_gw" {
  allocation_id = aws_eip.boiko_nat_eip.id
  subnet_id     = aws_subnet.boiko_public_subnet.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-NAT-GATEWAY-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Public Route Table
resource "aws_route_table" "boiko_public_rt" {
  vpc_id = aws_vpc.boiko_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-RT-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Route to Internet Gateway for Public Subnet
resource "aws_route" "boiko_public_route" {
  route_table_id         = aws_route_table.boiko_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.boiko_igw.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "boiko_public_subnet_association" {
  subnet_id      = aws_subnet.boiko_public_subnet.id
  route_table_id = aws_route_table.boiko_public_rt.id
}

# Private Route Table for Private Subnet (routes through NAT Gateway)
resource "aws_route_table" "boiko_private_rt" {
  vpc_id = aws_vpc.boiko_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-RT-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Route for Private Subnet to use NAT Gateway for Internet Access
resource "aws_route" "boiko_private_route" {
  route_table_id         = aws_route_table.boiko_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.boiko_nat_gw.id

}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "boiko_private_subnet_association" {
  subnet_id      = aws_subnet.boiko_private_subnet.id
  route_table_id = aws_route_table.boiko_private_rt.id
}

# Security Group for Public EC2 Instance
resource "aws_security_group" "boiko_public_sg" {
  vpc_id = aws_vpc.boiko_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-SG-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Security Group for Private EC2 Instance
resource "aws_security_group" "boiko_private_sg" {
  vpc_id = aws_vpc.boiko_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.boiko_public_sg.id] # Allow SSH only from public EC2 instance
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-SG-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Public EC2 Instance
resource "aws_instance" "boiko_public_instance" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.boiko_public_subnet.id

  # Error: creating EC2 Instance: operation error EC2: RunInstances,
  # https response error StatusCode: 400,
  # RequestID: f4a0e370-9c04-4c40-8c63-d6f3872bb172, api error InvalidParameterCombination:
  # The parameter groupName cannot be used with the parameter subnet

  # The error you're seeing is caused by specifying security_groups with a VPC-based subnet_id.
  # In VPC mode, security_groups should use security_group_ids instead of security_groups.
  # When you specify a subnet_id, Terraform expects you to use security_group_ids,
  # which refers to the security group's ID rather than its name.

  # security_groups = [aws_security_group.boiko_public_sg.name]
  vpc_security_group_ids = [aws_security_group.boiko_public_sg.id]
  # key_name      = aws_key_pair.andrii_boiko_key.key_name
  key_name = var.key_pair_name

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-INSTANCE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# Private EC2 Instance
resource "aws_instance" "boiko_private_instance" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.boiko_private_subnet.id
  # security_groups = [aws_security_group.boiko_private_sg.name]
  vpc_security_group_ids = [aws_security_group.boiko_private_sg.id]
  # key_name      = aws_key_pair.andrii_boiko_key.key_name
  key_name = var.key_pair_name

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PRIVATE-INSTANCE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}
