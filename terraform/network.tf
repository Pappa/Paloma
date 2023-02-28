
resource "aws_vpc" "paloma" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_internet_gateway" "paloma" {
  vpc_id = aws_vpc.paloma.id

  tags = {
    Name = "paloma"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.paloma.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.paloma.id
}

resource "aws_security_group" "paloma" {
  name   = "paloma"
  vpc_id = aws_vpc.paloma.id

  ingress {
    protocol  = "tcp"
    from_port = 2424
    to_port   = 2424
  }

  ingress {
    protocol  = "tcp"
    from_port = 2480
    to_port   = 2480
  }

  ingress {
    protocol  = "tcp"
    from_port = 3000
    to_port   = 3000
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.paloma.id
  cidr_block              = cidrsubnet(aws_vpc.paloma.cidr_block, 8, 2)
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true
}