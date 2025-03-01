# ------------------------------- Provider ---------------------------------------------------
provider "aws" {
  region = var.region
}

# ------------------------------- VPC ---------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-VPS-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# ------------------------------- Internet Gateway ---------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-INTERNET_GATEWAY-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# ------------------------------- NAT Gateway ---------------------------------------------------
resource "aws_eip" "nat" {
  # vpc = true
  domain = "vpc"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-EIP-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-NAT_GATEWAY-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# ------------------------------- Public Route Table ---------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-ROUTE_TABLE_PUBLIC-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}

# ------------------------------- Private Route Table ---------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-ROUTE_TABLE_PRIVATE-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private.id
}

# ------------------------------- Public Subnets ---------------------------------------------------
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PUBLIC_1-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PUBLIC_2-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1c"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PUBLIC_3-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

# ------------------------------- Private Subnets ---------------------------------------------------
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-central-1a"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PRIVATE_1-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-central-1b"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PRIVATE_2-%s-%s", var.owner, var.environment, var.project)
    }
  )
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-central-1c"
  tags = merge(
    local.common_tags,
    {
      Name = format("%s-SUBNET_PRIVATE_3-%s-%s", var.owner, var.environment, var.project)
    }
  )
}
