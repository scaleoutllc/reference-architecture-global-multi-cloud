module "team-dev" {
  source = "../../shared/terraform/aws-multizone"
  name   = "team"
  deployments = [
    { provider = "aws", region = "us" },
    { provider = "aws", region = "au" },
  ]
  parent_domain  = aws_route53_zone.dev.name // dev.wescaleout.cloud
  parent_zone_id = aws_route53_zone.dev.id
  depends_on     = [cloudflare_record.dev-delegate]
}

module "team-dev-cert" {
  source  = "../../shared/terraform/aws-multizone-star-cert"
  domain  = module.team-dev.zones.root.name // dev.wescaleout.cloud
  zone_id = module.team-dev.zones.root.id
  sans    = module.team-dev.sans
}

