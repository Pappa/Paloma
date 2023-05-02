data "aws_ami" "amazon_linux_2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}



data "aws_ami" "aws_optimized_ecs" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "graph" {
  ami                  = data.aws_ami.aws_optimized_ecs.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  user_data            = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.paloma.name}" >> /etc/ecs/ecs.config
EOF
}
