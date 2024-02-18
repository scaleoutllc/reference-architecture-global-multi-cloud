output "team-dev-au" {
  value = {
    zones           = merge(module.team-dev-zones.root, module.team-dev-zones.sans)
    certificate_arn = module.team-dev-cert.arn
  }
}
