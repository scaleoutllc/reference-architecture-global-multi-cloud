locals {
  // google certificates automatically cover the wildcard of the domain
  // supplied. slice away the first domain (the root), it is redundant
  // with the second. also strip "*." as prefix from each domain for
  // the same reason.
  gcp-au-domains = toset([
    for domain in slice(local.sans.gcp-au, 1, length(local.sans.gcp-au)) : replace(domain, "*.", "")
  ])
}

resource "google_certificate_manager_dns_authorization" "gcp-au" {
  for_each = local.gcp-au-domains
  provider = google.au
  type     = "PER_PROJECT_RECORD"
  name     = "gcp-au-${replace(each.value, ".", "-")}"
  domain   = each.value
}

resource "google_certificate_manager_certificate" "gcp-au" {
  provider = google.au
  name     = replace(local.domain, ".", "-")
  managed {
    domains            = local.sans.gcp-au
    dns_authorizations = [for auth in google_certificate_manager_dns_authorization.gcp-au : auth.id]
  }
}

resource "aws_route53_record" "gcp-au" {
  // no provider is specified because DNS records are stored in the default provider.
  for_each = {
    for validate in google_certificate_manager_dns_authorization.gcp-au : validate.domain => {
      name    = replace(validate.dns_resource_record[0].name, "${validate.domain}.", "")
      records = validate.dns_resource_record[0].data
      type    = validate.dns_resource_record[0].type
      // find the correct parent zone for each validation, or use the root team zone
      zone_id = lookup(local.zones, validate.domain, aws_route53_zone.team.id)
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.records]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
  depends_on = [
    aws_route53_zone.team,
    aws_route53_zone.provider,
    aws_route53_zone.region
  ]
}

resource "google_certificate_manager_certificate_map" "gcp-au" {
  provider = google.au
  name     = "gcp-au-${replace(local.domain, ".", "-")}"
}

resource "google_certificate_manager_certificate_map_entry" "gcp-au" {
  provider     = google.au
  for_each     = toset(local.sans.gcp-au)
  name         = replace(replace(each.value, ".", "-"), "*", "star")
  map          = google_certificate_manager_certificate_map.gcp-au.name
  certificates = [google_certificate_manager_certificate.gcp-au.id]
  hostname     = each.value
}
