# Provider
provider "aws" {
  region = var.aws_region
}

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

# Public EC2 Instance
resource "aws_instance" "boiko_public_instance" {
  count                  = 2
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.boiko_public_subnet.id
  vpc_security_group_ids = [aws_security_group.boiko_public_sg.id]
  key_name               = var.key_pair_name

  tags = merge(
    local.common_tags,
    {
      Name = format("%s-PUBLIC-INSTANCE-%s-%s-%d", var.owner, var.environment, var.project, count.index)
    }
  )
}

# Create inventory file
resource "null_resource" "inventory" {
  depends_on = [aws_instance.boiko_public_instance]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
cat > ${path.module}/ansible/hosts.ini <<EOF
[hw_21_servers]
${join("\n", slice(aws_instance.boiko_public_instance[*].public_ip, 0, 1))}
${join("\n", slice(aws_instance.boiko_public_instance[*].public_ip, 1, 2))}
EOF
EOT
  }
}
