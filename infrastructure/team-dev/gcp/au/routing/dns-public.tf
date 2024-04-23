resource "aws_route53_record" "public_apex" {
  zone_id = local.routing.zone_id
  name    = local.routing.domain
  type    = "A"
  ttl     = 60
  records = [google_compute_global_forwarding_rule.ingress.ip_address]
}

resource "aws_route53_record" "public_star" {
  zone_id = local.routing.zone_id
  name    = "*.${local.routing.domain}"
  type    = "A"
  ttl     = 60
  records = [google_compute_global_forwarding_rule.ingress.ip_address]
}
