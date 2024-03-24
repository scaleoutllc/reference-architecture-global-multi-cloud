output "domain" {
  value = local.domain
}

output "sans" {
  value = local.sans
}

output "certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "zones" {
  value = {
    team            = aws_route53_zone.team
    provider        = aws_route53_zone.provider
    fully-specified = aws_route53_zone.fully-specified
  }
}
