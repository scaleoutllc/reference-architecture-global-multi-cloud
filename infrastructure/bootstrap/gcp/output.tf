output "terraform-cloud-team-dev-au" {
  value = <<-EOF
Set the following as environment variables in Terraform Cloud:
TFC_GCP_PROVIDER_AUTH=true
TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL=${google_service_account.team-dev-au-tfc.email}
TFC_GCP_PROJECT_NUMBER=${google_project.team-dev-au.number}
TFC_GCP_WORKLOAD_POOL_ID=${google_iam_workload_identity_pool.team-dev-au-tfc.id}
TFC_GCP_WORKLOAD_PROVIDER_ID=${google_iam_workload_identity_pool_provider.team-dev-au-tfc.id}
EOF
}

output "terraform-cloud-team-dev-us" {
  value = <<-EOF
Set the following as environment variables in Terraform Cloud:
TFC_GCP_PROVIDER_AUTH=true
TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL=${google_service_account.team-dev-us-tfc.email}
TFC_GCP_PROJECT_NUMBER=${google_project.team-dev-us.number}
TFC_GCP_WORKLOAD_POOL_ID=${google_iam_workload_identity_pool.team-dev-us-tfc.id}
TFC_GCP_WORKLOAD_PROVIDER_ID=${google_iam_workload_identity_pool_provider.team-dev-us-tfc.id}
EOF
}
