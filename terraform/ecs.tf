resource "aws_ecs_task_definition" "paloma_db" {
  family                   = "paloma_db"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 2048
  
  container_definitions = file("ecs-task-definitions/paloma_db.json")
}