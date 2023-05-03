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

resource "aws_launch_template" "paloma" {
  image_id                             = data.aws_ami.aws_optimized_ecs.id
  instance_type                        = "t3.micro"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.paloma.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(templatefile("template_files/paloma_ec2_user_data.tftpl", {
    cluster_name = aws_ecs_cluster.paloma.name
  }))
}

resource "aws_autoscaling_group" "paloma" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  name             = "paloma"
  vpc_zone_identifier = [
    aws_subnet.paloma_public_subnet_1.id,
    aws_subnet.paloma_public_subnet_1.id
  ]

  instance_refresh {
    strategy = "Rolling"
  }

  launch_template {
    id      = aws_launch_template.paloma.id
    version = aws_launch_template.paloma.latest_version
  }
}
