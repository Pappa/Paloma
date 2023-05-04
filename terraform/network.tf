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
  public_subnets          = ["10.0.1.0/27", "10.0.1.32/27"]
  private_subnets         = ["10.0.2.0/27", "10.0.2.32/27"]
  availability_zones      = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
}

resource "aws_vpc" "paloma" {
  cidr_block           = local.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

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

resource "aws_subnet" "paloma_public" {
  count                   = length(local.public_subnets)
  vpc_id                  = aws_vpc.paloma.id
  cidr_block              = element(local.public_subnets, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Paloma - Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "paloma_private" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.paloma.id
  cidr_block        = element(local.private_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = "Paloma - Private Subnet ${count.index}"
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

resource "aws_route" "paloma_public" {
  route_table_id         = aws_route_table.paloma_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.paloma.id
}

resource "aws_route_table_association" "paloma_public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.paloma_public.*.id, count.index)
  route_table_id = aws_route_table.paloma_public.id
}

resource "aws_security_group" "paloma_service" {
  name        = "paloma"
  description = "Paloma security group"
  vpc_id      = aws_vpc.paloma.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.paloma_load_balancer.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Paloma security group"
  }
}

resource "aws_alb" "paloma_load_balancer" {
  name               = "Paloma ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.paloma_public.*.id
  security_groups    = [aws_security_group.paloma_load_balancer.id]

  tags = {
    Name = "Paloma ALB"
  }
}

resource "aws_security_group" "paloma_load_balancer" {
  vpc_id = aws_vpc.paloma.id

  ingress {
    from_port        = 2424
    to_port          = 2424
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 2480
    to_port          = 2480
    protocol         = "http"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Paloma ALB"
  }
}

resource "aws_lb_target_group" "paloma_http" {
  name        = "Paloma HTTP"
  port        = 2480
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.paloma.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/studio/index.html"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "Paloma HTTP"
  }
}

resource "aws_lb_listener" "paloma_http" {
  load_balancer_arn = aws_alb.paloma_load_balancer.id
  port              = "2480"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.paloma_http.id
  }
}
