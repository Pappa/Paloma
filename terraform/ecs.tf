resource "aws_ecs_cluster" "paloma" {
  name = var.paloma_ecs_cluster_name

  capacity_providers = [aws_ecs_capacity_provider.paloma.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.paloma.name
  }
}

resource "aws_ecs_capacity_provider" "paloma" {
  name = "paloma"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.paloma.arn
  }
}

resource "aws_ecs_task_definition" "paloma" {
  family                   = "paloma"
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 512
  container_definitions = templatefile("template_files/paloma_db.json.tftpl", {
    aws_region             = var.aws_region
    log_group              = aws_cloudwatch_log_group.paloma_ecs_task.name
    prefix                 = "paloma-"
    ORIENTDB_ROOT_PASSWORD = var.ORIENTDB_ROOT_PASSWORD
    ORIENTDB_OPTS_MEMORY   = "-Xmx512m"
  })

  depends_on = [aws_lb_listener.paloma_http]
}

resource "aws_ecs_service" "paloma" {
  name            = "paloma"
  cluster         = aws_ecs_cluster.paloma.id
  task_definition = aws_ecs_task_definition.paloma.arn
  desired_count   = 1
  #   deployment_minimum_healthy_percent = 100
  #   deployment_maximum_percent         = 200
  launch_type         = "EC2"
  scheduling_strategy = "REPLICA"

  depends_on = [
    aws_iam_role.ecs_task_execution,
    aws_iam_role.ecs_task
  ]

  network_configuration {
    subnets          = aws_subnet.paloma_private.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.paloma_service.id,
      aws_security_group.paloma_load_balancer.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.paloma_http.arn
    container_name   = "paloma"
    container_port   = 2480
  }

  #   lifecycle {
  #     ignore_changes = [task_definition]
  #   }
}

resource "aws_cloudwatch_log_group" "paloma_ecs_task" {
  name = "paloma"
}
