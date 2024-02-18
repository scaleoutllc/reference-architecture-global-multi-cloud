output "terraform-cloud" {
  value = <<-EOF
Set the following as environment variables in Terraform Cloud:
TFC_GCP_PROVIDER_AUTH=true
TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL=${google_service_account.tfc.email}
TFC_GCP_PROJECT_NUMBER=${google_project.main.number}
TFC_GCP_WORKLOAD_POOL_ID=${google_iam_workload_identity_pool.tfc.id}
TFC_GCP_WORKLOAD_PROVIDER_ID=${google_iam_workload_identity_pool_provider.tfc.id}
EOF
}
