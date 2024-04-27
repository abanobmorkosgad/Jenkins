resource "aws_subnet" "myapp-sub" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
    Name= "${var.env_prefix}-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-GW"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.myapp-sub.id
  route_table_id = var.default_route_table_id
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.env_prefix}-default-RT"
  }
}