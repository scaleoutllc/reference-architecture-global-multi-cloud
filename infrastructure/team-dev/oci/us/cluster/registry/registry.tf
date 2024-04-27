locals {
  endpoint = "${lower(data.oci_identity_tenancy.this_env.home_region_key)}.ocir.io"
  user     = "${oci_artifacts_container_configuration.main.namespace}/${oci_identity_user.registry.name}"
}

resource "oci_artifacts_container_configuration" "main" {
  compartment_id                      = var.compartment_id
  is_repository_created_on_first_push = true
}

resource "oci_identity_user" "registry" {
  compartment_id = var.compartment_id
  description    = "Registry Reader"
  name           = "registry-reader"
  email          = "registry@wescaleout.com"
}

resource "oci_identity_group" "registry-reader" {
  compartment_id = var.compartment_id
  description    = "Allow read access to container registry."
  name           = "registry-reader"
}

resource "oci_identity_policy" "registry-reader" {
  compartment_id = var.compartment_id
  description    = "Allow read access to container registry."
  name           = "registry-reader"
  statements = [
    "Allow group ${oci_identity_group.registry-reader.name} to read repos in tenancy"
  ]
}

resource "oci_identity_user_group_membership" "registry" {
  compartment_id = var.compartment_id
  group_id       = oci_identity_group.registry-reader.id
  user_id        = oci_identity_user.registry.id
}

resource "oci_identity_auth_token" "registry" {
  description = "cluster container registry access"
  user_id     = oci_identity_user.registry.id
}
