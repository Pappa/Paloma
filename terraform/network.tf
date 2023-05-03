locals {
  public_subnet_1         = "Paloma - Public Subnet 1"
  public_subnet_2         = "Paloma - Public Subnet 2"
  private_subnet_1        = "Paloma - Private Subnet 1"
  private_subnet_2        = "Paloma - Private Subnet 2"
  az_a                    = "${var.aws_region}a"
  az_b                    = "${var.aws_region}b"
  az_c                    = "${var.aws_region}c"
  vpc_name                = "Paloma VPC"
  vpc_cidr                = "10.0.0.0/16"
  public_subnet_az1_cidr  = "10.0.1.0/27"
  public_subnet_az2_cidr  = "10.0.1.32/27"
  private_subnet_az1_cidr = "10.0.2.0/27"
  private_subnet_az2_cidr = "10.0.2.32/27"
}

resource "aws_vpc" "paloma" {
  cidr_block           = local.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = local.vpc_name
  }

}

resource "aws_internet_gateway" "paloma" {
  vpc_id = aws_vpc.paloma.id

  tags = {
    Name = "${local.vpc_name} Internet Gateway"
  }
}

resource "aws_subnet" "paloma_public_subnet_1" {
  vpc_id            = aws_vpc.paloma.id
  availability_zone = local.az_a
  cidr_block        = local.public_subnet_az1_cidr

  tags = {
    Name = local.public_subnet_1
  }
}

resource "aws_subnet" "paloma_public_subnet_2" {
  vpc_id            = aws_vpc.paloma.id
  availability_zone = local.az_b
  cidr_block        = local.public_subnet_az2_cidr

  tags = {
    Name = local.public_subnet_2
  }
}

resource "aws_subnet" "paloma_private_subnet_1" {
  vpc_id            = aws_vpc.paloma.id
  availability_zone = local.az_a
  cidr_block        = local.private_subnet_az1_cidr

  tags = {
    Name = local.private_subnet_1
  }
}

resource "aws_subnet" "paloma_private_subnet_2" {
  vpc_id            = aws_vpc.paloma.id
  availability_zone = local.az_b
  cidr_block        = local.private_subnet_az2_cidr

  tags = {
    Name = local.private_subnet_2
  }
}

resource "aws_route_table" "paloma_public" {
  vpc_id = aws_vpc.paloma.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.paloma.id
  }

  tags = {
    Name = "Paloma - Public route table"
  }
}

resource "aws_route_table_association" "paloma_public_subnet_1" {
  subnet_id      = aws_subnet.paloma_public_subnet_1.id
  route_table_id = aws_route_table.paloma_public.id
}


resource "aws_route_table_association" "paloma_public_subnet_2" {
  subnet_id      = aws_subnet.paloma_public_subnet_2.id
  route_table_id = aws_route_table.paloma_public.id
}

resource "aws_route_table" "paloma_private_subnet_1" {
  vpc_id = aws_vpc.paloma.id

  tags = {
    Name = "Paloma - ${local.private_subnet_1} route table"
  }
}

resource "aws_route_table" "paloma_private_subnet_2" {
  vpc_id = aws_vpc.paloma.id

  tags = {
    Name = "Paloma - ${local.private_subnet_2} route table"
  }
}

resource "aws_route_table_association" "paloma_private_subnet_1" {
  subnet_id      = aws_subnet.paloma_private_subnet_1.id
  route_table_id = aws_route_table.paloma_private_subnet_1.id
}


resource "aws_route_table_association" "paloma_private_subnet_2" {
  subnet_id      = aws_subnet.paloma_private_subnet_2.id
  route_table_id = aws_route_table.paloma_private_subnet_2.id
}



resource "aws_security_group" "paloma" {
  name        = "paloma"
  description = "Paloma security group"
  vpc_id      = aws_vpc.paloma.id

  ingress {
    protocol  = "tcp"
    from_port = 2424
    to_port   = 2424
  }

  ingress {
    protocol  = "http"
    from_port = 2480
    to_port   = 2480
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      local.public_subnet_az1_cidr,
      local.public_subnet_az2_cidr
    ]
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  #   ingress {
  #     protocol  = "tcp"
  #     from_port = 2424
  #     to_port   = 2424
  #   }

  #   ingress {
  #     protocol  = "http"
  #     from_port = 2480
  #     to_port   = 2480
  #   }

  #   egress {
  #     protocol    = "-1"
  #     from_port   = 0
  #     to_port     = 0
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
}

resource "aws_network_interface" "paloma" {
  subnet_id       = aws_subnet.paloma_public_subnet_1.id
  security_groups = [aws_security_group.paloma.id]

  attachment {
    instance     = aws_instance.graph.id
    device_index = 1
  }
}
