resource "tls_private_key" "terraform-team-dev-us" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_identity_user" "terraform-team-dev-us" {
  compartment_id = local.team-dev-us.compartment_id
  description    = "Terraform Cloud"
  name           = "terraform-cloud"
  email          = "info@wescaleout.com"
}

resource "oci_identity_api_key" "terraform-team-dev-us" {
  key_value = tls_private_key.terraform-team-dev-us.public_key_pem
  user_id   = oci_identity_user.terraform-team-dev-us.id
}

resource "oci_identity_user_group_membership" "terraform-team-dev-us-admin" {
  group_id = local.team-dev-us.admin_group_id
  user_id  = oci_identity_user.terraform-team-dev-us.id
}
