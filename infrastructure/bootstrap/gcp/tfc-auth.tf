locals {
  tfc = {
    hostname = "app.terraform.io"
    audience = "aws.workload.identity"
  }
}

resource "google_iam_workload_identity_pool" "tfc" {
  project                   = google_project.main.name
  workload_identity_pool_id = "scaleout-platform"
  depends_on                = [google_project_service.main]
}

resource "google_iam_workload_identity_pool_provider" "tfc" {
  project                            = google_project.main.name
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
  workload_identity_pool_provider_id = "terraform-cloud"
  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri = "https://${local.tfc.hostname}"
  }
  attribute_condition = "assertion.sub.startsWith(\"organization:scaleout:project:${google_project.main.name}:workspace:*\")"
}

resource "google_service_account" "tfc" {
  project      = google_project.main.name
  account_id   = "tfc-service-account"
  display_name = "Terraform Cloud Service Account"
  depends_on   = [google_project_service.main]
}

resource "google_service_account_iam_member" "tfc" {
  service_account_id = google_service_account.tfc.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc.name}/*"
}

resource "google_project_iam_member" "tfc_project_member" {
  project = google_project.main.name
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.tfc.email}"
}
