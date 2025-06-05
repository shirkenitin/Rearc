resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name              = "/ecs/${var.environment}-${var.project_name}-cluster"
  retention_in_days = 30
  tags = local.common_tags
}

resource "aws_ecs_cluster" "quest" {
  name = "${var.environment}-${var.project_name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = local.common_tags
}
resource "aws_ecs_cluster_capacity_providers" "quest" {
  cluster_name = aws_ecs_cluster.quest.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}



resource "aws_ecs_task_definition" "quest" {
  family                   = "${var.environment}-${var.project_name}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "${var.environment}-${var.project_name}-backend"
      image     = "${aws_ecr_repository.quest.repository_url}:latest"
      essential = true
      # Enable interactive command execution
      interactive    = true
      pseudoTerminal = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_cluster.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "secret_word"
          value = "secret"
        }
      ]
      linuxParameters = {
        init_process_enabled = true
      }
    }
    ]
  )


  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  depends_on = [aws_cloudwatch_log_group.ecs_cluster,aws_ecr_repository.quest]
  tags       = local.common_tags
}



# ECS Service
resource "aws_ecs_service" "quest" {
  name                   = "${var.environment}-${var.project_name}-service"
  cluster                = aws_ecs_cluster.quest.id
  task_definition        = aws_ecs_task_definition.quest.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "ECS" # Use native ECS deployments instead of CodeDeploy
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # Required for rollback to work properly
  health_check_grace_period_seconds = 60

  load_balancer {
    target_group_arn = aws_lb_target_group.quest_lb_tg.arn
    container_name   = "${var.environment}-${var.project_name}-backend"
    container_port   = 3000
  }

  tags = local.common_tags
   depends_on = [aws_lb_listener.quest_lb_listener]
}



resource "aws_security_group" "ecs_service" {
  name        = "${var.environment}-${var.project_name}-ecs-sg"
  description = "Allow inbound access from LB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id] ####update LB SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { "Name" = "${var.environment}-${var.project_name}-ecs-sg" },
    local.common_tags
  )
}
