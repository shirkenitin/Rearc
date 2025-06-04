resource "aws_iam_role" "ecs_task_execution_role" {
  name        = "${var.environment}-${var.project_name}-ecs-cluster-execution-role"
  description = "Allows ECS tasks to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = local.common_tags
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs-task-execution-policy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_exec_policy" {
  name = "${var.environment}-${var.project_name}-ecs-cluster-exec-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup"
        ],
        Resource = [
          aws_cloudwatch_log_group.ecs_cluster.arn
        ]
      }
    ]
  })
  depends_on = [ aws_cloudwatch_log_group.ecs_cluster ]
}
