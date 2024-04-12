// this cert is hosted in the default region and thus does not have a
// provider reference for each resource. if copying for a new region
// in aws, use any other aws cert file as a reference.
resource "aws_acm_certificate" "aws-us" {
  domain_name               = local.domain
  subject_alternative_names = local.sans.aws-us
  validation_method         = "DNS"
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_acm_certificate_validation" "aws-us" {
  certificate_arn         = aws_acm_certificate.aws-us.arn
  validation_record_fqdns = [for record in aws_route53_record.aws-us : record.fqdn]
}

resource "aws_route53_record" "aws-us" {
  for_each = {
    for validate in aws_acm_certificate.aws-us.domain_validation_options : validate.domain_name => {
      name   = validate.resource_record_name
      record = validate.resource_record_value
      type   = validate.resource_record_type
      // find the correct parent zone for each validation, or use the root team zone
      zone_id = lookup(local.zones, replace(validate.domain_name, "*.", ""), aws_route53_zone.team.id)
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
