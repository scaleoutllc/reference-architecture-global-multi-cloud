output "host" {
  value = local.endpoint
}

output "username" {
  value = local.user
}

output "password" {
  value     = oci_identity_auth_token.registry.token
  sensitive = true
}

// made up, any output would be valid
output "email" {
  value = "${local.name}@docker.io"
}
