output "team-dev" {
  value = merge({
    certificate_arn = module.team-dev-cert.arn
  }, module.team-dev)
}
