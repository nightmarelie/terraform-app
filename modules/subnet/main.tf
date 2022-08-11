resource "aws_subnet" "dev-app-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.available_zone
  tags = {
    Name : "${var.environment}-subnet-1"
    vpc_env : var.environment
  }
}

resource "aws_internet_gateway" "dev-app-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-app-igw.id
  }
  tags = {
    Name = "${var.environment}-main-rtb"
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
