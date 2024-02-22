output "domain" {
  value = local.domain
}

output "sans" {
  value = local.sans
}

output "zones" {
  value = {
    for item in local.deployments : "${item.provider}-${item.region}" => [
      aws_route53_zone.provider[item.provider],
      aws_route53_zone.region[item.region],
      aws_route53_zone.composite["${item.provider}-${item.region}"],
      //"${aws_route53_zone.composite["${item.region}-${item.provider}"]
    ]
  }
}

output "certificate_arn" {
  value = aws_acm_certificate.main.arn
}
