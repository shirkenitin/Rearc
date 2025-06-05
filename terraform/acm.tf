resource "aws_acm_certificate" "tls_cert" {
  domain_name       = "rearccasestudy.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "main" {
  name = "${var.environment}-${var.project_name}-zone"
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.tls_cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.tls_cert.domain_validation_options[0].resource_record_type
  zone_id = var.route53_zone_id
  records = [aws_acm_certificate.tls_cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.tls_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.quest_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest_lb_tg.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.quest_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

