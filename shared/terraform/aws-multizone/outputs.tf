output "sans" {
  value = merge(
    { for key, zone in module.provider : zone.name => zone.id },
    { for key, zone in module.region : zone.name => zone.id },
    { for key, zone in module.composite : zone.name => zone.id }
  )
}

output "root" {
  value = {
    (module.root.name) = module.root.id
  }
}

output "root_id" {
  value = module.root.id
}
