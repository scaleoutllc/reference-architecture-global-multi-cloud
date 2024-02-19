locals {
  sans = [for domain, zone in var.sans : ["*.${domain}", domain]]
}

resource "aws_acm_certificate" "main" {
  domain_name               = var.domain
  subject_alternative_names = flatten(["*.${var.domain}", local.sans])
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
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = lookup(var.sans, replace(dvo.domain_name, "*.", ""), var.zone_id)
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}
