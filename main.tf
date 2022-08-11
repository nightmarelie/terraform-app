provider "aws" {
  region = "ca-central-1"
}

resource "aws_vpc" "dev-app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.environment}-vpc"
    vpc_env : var.environment
  }
}

module "dev-app-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  environment            = var.environment
  available_zone         = var.available_zone
  vpc_id                 = aws_vpc.dev-app-vpc.id
  default_route_table_id = aws_vpc.dev-app-vpc.default_route_table_id
}

module "dev-app-webserver" {
  source               = "./modules/webserver"
  environment          = var.environment
  available_zone       = var.available_zone
  my_ip                = var.my_ip
  public_key_location  = var.public_key_location
  private_key_location = var.private_key_location
  vpc_id               = aws_vpc.dev-app-vpc.id
  image_name           = var.image_name
  instance_type        = var.instance_type
  subnet_id            = module.dev-app-subnet.subnet.id
}
