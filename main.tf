provider "aws" {
  region     = "ca-central-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name : "development"
    vpc_env : "dev"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ca-central-1a"
  tags = {
    Name : "subnet-1-development",
    vpc_env : "dev"
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
