resource "aws_iam_role" "ecs_task_execution" {
  name               = "paloma_db_ecs_task_execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    aws_iam_policy.ecs_logs.arn
  ]
}

resource "aws_iam_role" "ecs_task" {
  name               = "paloma_db_ecs_task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    aws_iam_policy.ecs_logs.arn
  ]
}

resource "aws_iam_policy" "ecs_logs" {
  name   = "paloma-ecs-logs"
  policy = data.aws_iam_policy_document.ecs_logs.json
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = ["arn:aws:ecs:${var.aws_region}:${var.aws_account}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [var.aws_account]
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

data "aws_iam_policy_document" "ecs_instance_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecsInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name       = "ecsInstanceProfile"
  role       = aws_iam_role.ecs_instance_role.name
  depends_on = [aws_iam_role_policy_attachment.ecs_instance_role]
}
