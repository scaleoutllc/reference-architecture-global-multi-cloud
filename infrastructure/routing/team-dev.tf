module "team-dev-zones" {
  source = "../../shared/terraform/aws-multizone"
  name   = "team"
  // temporarily disable some domains until ACM ups our limit.
  providerRegions = {
    aws = ["us"] //, "au"]
    // gcp = ["us"]
  }
  parent_domain  = aws_route53_zone.dev.name
  parent_zone_id = aws_route53_zone.dev.id
  depends_on     = [cloudflare_record.dev-delegate]
}

module "team-dev-cert" {
  source   = "../../shared/terraform/aws-multizone-star-cert"
  domain   = "team.dev.wescaleout.cloud"
  zone_id  = module.team-dev-zones.root_id
  sanZones = module.team-dev-zones.sans
}
