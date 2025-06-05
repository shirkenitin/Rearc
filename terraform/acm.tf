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
  zone_id = aws_route53_zone.main.zone_id
  records = [aws_acm_certificate.tls_cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.tls_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}


