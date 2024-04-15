output "domain" {
  value = local.domain
}

output "aws-us" {
  value = {
    certificate_arn = aws_acm_certificate.aws-us.arn
    domain          = aws_route53_zone.fully-specified["aws-us"].name
    zone_id         = aws_route53_zone.fully-specified["aws-us"].id
  }
}

output "aws-au" {
  value = {
    certificate_arn = aws_acm_certificate.aws-au.arn
    domain          = aws_route53_zone.fully-specified["aws-au"].name
    zone_id         = aws_route53_zone.fully-specified["aws-au"].id
  }
}

output "gcp-us" {
  value = {
    certificate_map_id = google_certificate_manager_certificate_map.gcp-us.id
    domain             = aws_route53_zone.fully-specified["gcp-us"].name
    zone_id            = aws_route53_zone.fully-specified["gcp-us"].id
  }
}

output "gcp-au" {
  value = {
    certificate_map_id = google_certificate_manager_certificate_map.gcp-au.id
    domain             = aws_route53_zone.fully-specified["gcp-au"].name
    zone_id            = aws_route53_zone.fully-specified["gcp-au"].id
  }
}

output "zones" {
  value = {
    team            = aws_route53_zone.team
    provider        = aws_route53_zone.provider
    fully-specified = aws_route53_zone.fully-specified
  }
}
