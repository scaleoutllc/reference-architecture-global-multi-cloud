resource "google_certificate_manager_dns_authorization" "main" {
  project = var.project
  name    = replace(var.domain, ".", "-")
  domain  = var.domain
}

resource "google_dns_record_set" "authorize" {
  project      = var.project
  managed_zone = replace(var.domain, ".", "-")
  name         = google_certificate_manager_dns_authorization.main.dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.main.dns_resource_record[0].type
  rrdatas = [
    google_certificate_manager_dns_authorization.main.dns_resource_record[0].data
  ]
}

resource "google_certificate_manager_certificate" "main" {
  project = var.project
  name    = replace(var.domain, ".", "-")
  managed {
    domains = [
      var.domain,
      "*.${var.domain}"
    ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.main.id
    ]
  }
}

resource "google_certificate_manager_certificate_map" "main" {
  project = var.project
  name    = replace(var.domain, ".", "-")
}

resource "google_certificate_manager_certificate_map_entry" "wildcard" {
  project      = var.project
  name         = "wildcard-${replace(var.domain, ".", "-")}"
  map          = google_certificate_manager_certificate_map.main.name
  certificates = [google_certificate_manager_certificate.main.id]
  hostname     = "*.${var.domain}"
}

resource "google_certificate_manager_certificate_map_entry" "apex" {
  project      = var.project
  name         = "apex-${replace(var.domain, ".", "-")}"
  map          = google_certificate_manager_certificate_map.main.name
  certificates = [google_certificate_manager_certificate.main.id]
  hostname     = var.domain
}
