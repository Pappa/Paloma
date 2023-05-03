resource "aws_ecs_cluster" "paloma" {
  name = "paloma"
}

resource "aws_ecs_task_definition" "paloma" {
  family                   = "paloma"
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 512
  container_definitions = templatefile("ecs-task-definitions/paloma_db.json.tftpl", {
    aws_region             = var.aws_region
    log_group              = aws_cloudwatch_log_group.paloma_ecs_task.name
    prefix                 = "paloma-"
    ORIENTDB_ROOT_PASSWORD = var.ORIENTDB_ROOT_PASSWORD
    ORIENTDB_OPTS_MEMORY   = "-Xmx512m"
  })
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
    security_groups  = [aws_security_group.paloma.id]
    subnets          = [aws_subnet.paloma_public.id]
    assign_public_ip = true
  }

  #  load_balancer {
  #    target_group_arn = var.aws_alb_target_group_arn
  #    container_name   = "paloma"
  #    container_port   = var.container_port
  #  }

  #   lifecycle {
  #     ignore_changes = [task_definition]
  #   }
}

resource "aws_cloudwatch_log_group" "paloma_ecs_task" {
  name = "paloma"
}
