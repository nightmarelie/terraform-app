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

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "development"
    vpc_env : var.environment
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "ca-central-1a"
  tags = {
    Name : "subnet-1-development",
    vpc_env : var.environment
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}



resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "ca-central-1a"
  tags = {
    Name : "subnet-2-default"
    vpc_env : "default"
  }
}
