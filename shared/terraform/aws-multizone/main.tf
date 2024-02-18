module "root" {
  source         = "./delegate-zone"
  domain         = "${var.name}.${var.parent_domain}"
  parent_zone_id = var.parent_zone_id
}

module "provider" {
  source         = "./delegate-zone"
  for_each       = toset(keys(var.providerRegions))
  domain         = "${each.value}.${module.root.name}"
  parent_zone_id = module.root.id
}

module "region" {
  source         = "./delegate-zone"
  for_each       = toset(flatten(values(var.providerRegions)))
  domain         = "${each.value}.${module.root.name}"
  parent_zone_id = module.root.id
}

module "composite" {
  source = "./delegate-zone"
  for_each = toset(flatten([for provider, regions in var.providerRegions : [
    [for region in regions : [
      "${provider}-${region}" /*, "${region}-${provider}"*/
    ]]
  ]]))
  domain         = "${each.value}.${module.root.name}"
  parent_zone_id = module.root.id
}
