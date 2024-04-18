resource "aws_route53_record" "public_apex" {
  zone_id = local.routing.zone_id
  name    = local.routing.domain
  type    = "A"
  alias {
    name                   = aws_lb.public_ingress.dns_name
    zone_id                = aws_lb.public_ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "public_star" {
  zone_id = local.routing.zone_id
  name    = "*.${local.routing.domain}"
  type    = "A"
  alias {
    name                   = aws_lb.public_ingress.dns_name
    zone_id                = aws_lb.public_ingress.zone_id
    evaluate_target_health = true
  }
}
