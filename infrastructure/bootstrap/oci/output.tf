output "terraform-cloud-team-dev-us" {
  value     = <<-EOF
Set the following as environment variables in Terraform Cloud:
export TF_VAR_tenancy_ocid=${local.team-dev-us.tenancy_id}
export TF_VAR_compartment_ocid=${local.team-dev-us.compartment_id}
export TF_VAR_user_ocid=${oci_identity_user.terraform-team-dev-us.id}
export TF_VAR_fingerprint=${tls_private_key.terraform-team-dev-us.public_key_fingerprint_md5}
export TF_VAR_private_key=${tls_private_key.terraform-team-dev-us.private_key_pem}
EOF
  sensitive = true
}
