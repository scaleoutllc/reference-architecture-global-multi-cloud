locals {
  zones = merge(
    { for key, zone in aws_route53_zone.provider : "${zone.name}" => zone.id },
    { for key, zone in aws_route53_zone.region : "${zone.name}" => zone.id },
    { for key, zone in aws_route53_zone.fully-specified : "${zone.name}" => zone.id }
  )
  sans = flatten([
    "*.${local.domain}",
    [for domain, zone in local.zones : ["*.${domain}", domain]]
  ])
}

resource "aws_acm_certificate" "main" {
  domain_name               = local.domain
  subject_alternative_names = local.sans
  validation_method         = "DNS"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validate : record.fqdn]
}

resource "aws_route53_record" "validate" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      // find the correct parent zone for each validation, or use the root team zone
      zone_id = lookup(local.zones, replace(dvo.domain_name, "*.", ""), aws_route53_zone.team.id)
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
  depends_on = [
    aws_route53_zone.team,
    aws_route53_zone.provider,
    aws_route53_zone.region
  ]
}
