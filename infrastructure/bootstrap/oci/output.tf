output "terraform-cloud-team-dev-us" {
  value     = <<-EOF
# Set the following as _environment variables_ in Terraform Cloud (not terraform
# variables). No variable blocks are required in the provider for these. The go
# SDK for OCI accepts TF_VAR as a prefix and uses it directly whether you are
# using terraform or not. See: https://github.com/oracle/oci-go-sdk/pull/494
export TF_VAR_tenancy_ocid=${local.team-dev-us.tenancy_id}
export TF_VAR_compartment_ocid=${local.team-dev-us.compartment_id}
export TF_VAR_user_ocid=${oci_identity_user.terraform-team-dev-us.id}
export TF_VAR_fingerprint=${oci_identity_api_key.terraform-team-dev-us.fingerprint}

# Terraform cloud does not support mutli-line env vars, decode in workspaces and
# assign manually to the provider with base64decode.
export TF_VAR_oci_private_key=${base64encode(tls_private_key.terraform-team-dev-us.private_key_pem)}

# Set the following environment variables for oci-cli for fetching a token to 
# clusters. The go sdk used by the oci provider does not respect the environment
# variable used by the python-based cli.
# See: https://github.com/oracle/oci-go-sdk/issues/495
export OCI_CLI_USER=${oci_identity_user.terraform-team-dev-us.id}
export OCI_CLI_REGION="us-chicago-1"
export OCI_CLI_FINGERPRINT=${oci_identity_api_key.terraform-team-dev-us.fingerprint}
export OCI_CLI_TENANCY=${local.team-dev-us.tenancy_id}
# Terraform cloud does not support mutli-line env vars, decode in workspaces.
export OCI_CLI_KEY_CONTENT=${base64encode(tls_private_key.terraform-team-dev-us.private_key_pem)}
EOF
  sensitive = true
}
