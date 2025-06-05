output "alb_dns" {
  value = aws_lb.quest_lb.dns_name
}