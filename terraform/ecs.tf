resource "aws_ecs_task_definition" "paloma_db" {
  family                   = "paloma_db"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      image       = "docker.io/orientdb:latest"
      cpu         = 1024
      memory      = 2048
      name        = "paloma_db"
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}