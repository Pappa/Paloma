resource "aws_iam_role" "ecs_task_execution" {
  name               = "paloma_db"
  assume_role_policy = file("policies/assume-role/ecs_task_execution.json")
}

resource "aws_iam_role" "ecs_task" {
  name               = "paloma_db"
  assume_role_policy = file("policies/assume-role/ecs_task.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}