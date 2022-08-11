provider "aws" {
  region = "ca-central-1"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
}

variable "environment" {
  description = "environment"
}

variable "available_zone" {
  description = "available zone"
}

variable "my_ip" {}

resource "aws_vpc" "dev-app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.environment}-vpc"
    vpc_env : var.environment
  }
}

resource "aws_subnet" "dev-app-subnet-1" {
  vpc_id            = aws_vpc.dev-app-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.available_zone
  tags = {
    Name : "${var.environment}-subnet-1"
    vpc_env : var.environment
  }
}

resource "aws_internet_gateway" "dev-app-igw" {
  vpc_id = aws_vpc.dev-app-vpc.id
  tags = {
    Name = "${var.environment}-igw"
  }
}

# resource "aws_route_table" "dev-app-route-table" {
#   vpc_id = aws_vpc.dev-app-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.dev-app-igw.id
#   }

#   # default route, mapping VPC CIDR block to "local", created implicitly and cannot be specified.

#   tags = {
#     Name = "${var.environment}-rtb"
#   }
# }

# # Associate subnet with Route Table
# resource "aws_route_table_association" "dev-app-rtb-subnet" {
#   subnet_id      = aws_subnet.dev-app-subnet-1.id
#   route_table_id = aws_route_table.dev-app-route-table.id
# }

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.dev-app-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-app-igw.id
  }
  tags = {
    Name = "${var.environment}-main-rtb"
  }
}

resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.dev-app-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.environment}-default-sg"
  }
}


