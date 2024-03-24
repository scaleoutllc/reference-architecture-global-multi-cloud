output "name_servers" {
  value = google_dns_managed_zone.main.name_servers
}

output "name" {
  value = replace(var.domain, ".", "-")
}
