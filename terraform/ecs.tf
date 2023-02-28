resource "aws_ecs_cluster" "cluster" {
  name = "paloma"
}

resource "aws_ecs_task_definition" "paloma_db" {
  family                   = "paloma_db"
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = file("ecs-task-definitions/paloma_db.json")
}