
resource "aws_vpc" "paloma" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
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
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}