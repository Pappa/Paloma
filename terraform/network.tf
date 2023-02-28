
resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# resource "aws_security_group" "paloma_db" {
#   name        = "paloma_db"
#   vpc_id      = aws_vpc.default.id

#   ingress {
#     protocol        = "tcp"
#     from_port       = 2424
#     to_port         = 2424
#     security_groups = [aws_security_group.lb.id]
#   }

#   ingress {
#     protocol        = "tcp"
#     from_port       = 2480
#     to_port         = 2480
#     security_groups = [aws_security_group.lb.id]
#   }

#   ingress {
#     protocol        = "tcp"
#     from_port       = 3000
#     to_port         = 3000
#     security_groups = [aws_security_group.lb.id]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }