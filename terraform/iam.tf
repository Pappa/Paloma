resource "aws_iam_role" "ecs_task_execution" {
  name               = "paloma_db_ecs_task_execution"
  assume_role_policy = data.aws_iam_policy_document.ecs.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    aws_iam_policy.ecs_logs.arn
  ]
}

resource "aws_iam_role" "ecs_task" {
  name               = "paloma_db_ecs_task"
  assume_role_policy = data.aws_iam_policy_document.ecs.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    aws_iam_policy.ecs_logs.arn
  ]
}

resource "aws_iam_policy" "ecs_logs" {
  name   = "paloma-ecs-logs"
  policy = data.aws_iam_policy_document.ecs_logs.json
}

data "aws_iam_policy_document" "ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "ecs_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}
