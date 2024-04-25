resource "aws_route53_record" "public_apex" {
  zone_id = local.routing.zone_id
  name    = local.routing.domain
  type    = "A"
  ttl     = 60
  records = [oci_load_balancer_load_balancer.public-ingress.ip_address_details[0].ip_address]
}

resource "aws_route53_record" "public_star" {
  zone_id = local.routing.zone_id
  name    = "*.${local.routing.domain}"
  type    = "A"
  ttl     = 60
  records = [oci_load_balancer_load_balancer.public-ingress.ip_address_details[0].ip_address]
}

