resource "aws_iam_role" "ecs_task_execution" {
  name               = "paloma_db_ecs_task_execution"
  assume_role_policy = file("policies/assume-role/ecs_task_execution.json")
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    aws_iam_policy.ecs_logs.arn
  ]
}

resource "aws_iam_role" "ecs_task" {
  name               = "paloma_db_ecs_task"
  assume_role_policy = file("policies/assume-role/ecs_task.json")
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    aws_iam_policy.ecs_logs.arn
  ]
}

resource "aws_iam_policy" "ecs_logs" {
    name = "paloma-ecs-logs"
    policy = file("policies/ecs_logs.json")
}