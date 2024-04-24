output "terraform-cloud-team-dev-us" {
  value     = <<-EOF
Set the following as _environment variables_ in Terraform Cloud (not terraform
variables). No variable blocks are required in terraform for these. The go SDK
for OCI accepts TF_VAR as a prefix and uses it directly whether you are using
terraform or not. See: https://github.com/oracle/oci-go-sdk/pull/494
export TF_VAR_tenancy_ocid=${local.team-dev-us.tenancy_id}
export TF_VAR_compartment_ocid=${local.team-dev-us.compartment_id}
export TF_VAR_user_ocid=${oci_identity_user.terraform-team-dev-us.id}
export TF_VAR_fingerprint=${oci_identity_api_key.terraform-team-dev-us.fingerprint}
Set this one as a terraform variable (terraform cloud doesn't support multiline env vars)
oci_private_key=${tls_private_key.terraform-team-dev-us.private_key_pem}
EOF
  sensitive = true
}
