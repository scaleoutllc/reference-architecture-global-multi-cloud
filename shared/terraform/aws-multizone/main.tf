locals {
  providers = toset([for env in var.deployments : env.provider])
  regions   = toset([for env in var.deployments : env.region])
  composite = toset(flatten([for provider in local.providers : [
    [for region in local.regions : [
      "${provider}-${region}" /*, "${region}-${provider}"*/
    ]]
  ]]))
}

module "root" {
  source         = "./delegate-zone"
  domain         = "${var.name}.${var.parent_domain}"
  parent_zone_id = var.parent_zone_id
}

module "provider" {
  source         = "./delegate-zone"
  for_each       = local.providers
  domain         = "${each.value}.${module.root.name}"
  parent_zone_id = module.root.id
}

module "region" {
  source         = "./delegate-zone"
  for_each       = local.regions
  domain         = "${each.value}.${module.root.name}"
  parent_zone_id = module.root.id
}

module "composite" {
  source         = "./delegate-zone"
  for_each       = local.composite
  domain         = "${each.value}.${module.root.name}"
  parent_zone_id = module.root.id
}
