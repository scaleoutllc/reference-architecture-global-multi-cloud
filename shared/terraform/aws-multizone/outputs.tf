output "zones" {
  value = {
    root      = module.root
    provider  = module.provider
    region    = module.region
    composite = module.composite
  }
}

output "sans" {
  value = merge(
    { for key, zone in module.provider : "${zone.name}" => zone.id },
    { for key, zone in module.region : "${zone.name}" => zone.id },
    { for key, zone in module.composite : "${zone.name}" => zone.id }
  )
}

output "environments" {
  value = {
    for item in var.deployments : "${item.provider}-${item.region}" => [
      module.root,
      module.provider[item.provider],
      module.region[item.region],
      module.composite["${item.provider}-${item.region}"],
      //"${module.composite["${item.region}-${item.provider}"]
    ]
  }
}

