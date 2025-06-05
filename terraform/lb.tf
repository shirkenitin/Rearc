resource "aws_security_group" "lb" {
  name        = "${var.environment}-${var.project_name}-lb-sg"
  description = "Security group for LB to ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.environment}-${var.project_name}-lb-sg" },
    local.common_tags
  )
}


resource "aws_lb" "quest_lb" {
  name               = "${var.environment}-${var.project_name}-quest-lb"
  internal           = false   #  MUST be false for public access
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.lb.id]

  enable_deletion_protection = false


  tags = merge(
    { Name = "${var.environment}-${var.project_name}-private-nlb" },
    local.common_tags
  )
}


resource "aws_lb_target_group" "quest_lb_tg" {
  name        = "${var.environment}-${var.project_name}-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = local.common_tags
  target_health_state {
    enable_unhealthy_connection_termination = false
  }
}


resource "aws_lb_listener" "quest_lb_listener" {
  load_balancer_arn = aws_lb.quest_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest_lb_tg.arn
  }
}
