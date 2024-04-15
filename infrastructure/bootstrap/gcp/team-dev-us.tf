resource "google_project" "team-dev-us" {
  project_id      = "scaleout-team-dev-us"
  name            = "scaleout-team-dev-us"
  billing_account = "0107CC-5B0989-308B51"
  org_id          = "140123624504"
}

resource "google_project_service" "team-dev-us" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
    "dns.googleapis.com",
    "certificatemanager.googleapis.com",
  ])
  project            = google_project.team-dev-us.name
  service            = each.key
  disable_on_destroy = true
}

resource "google_iam_workload_identity_pool" "team-dev-us-tfc" {
  project                   = google_project.team-dev-us.name
  workload_identity_pool_id = "scaleout-team-dev-us"
  depends_on                = [google_project_service.team-dev-us]
}

resource "google_iam_workload_identity_pool_provider" "team-dev-us-tfc" {
  project                            = google_project.team-dev-us.name
  workload_identity_pool_id          = google_iam_workload_identity_pool.team-dev-us-tfc.workload_identity_pool_id
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
  attribute_condition = "assertion.sub.startsWith(\"organization:scaleout:project:${google_project.team-dev-us.name}:workspace:*\")"
}

resource "google_service_account" "team-dev-us-tfc" {
  project      = google_project.team-dev-us.name
  account_id   = "tfc-team-dev-us-sa"
  display_name = "Terraform Cloud Service Account"
  depends_on   = [google_project_service.team-dev-us]
}

resource "google_service_account_iam_member" "team-dev-us-tfc" {
  service_account_id = google_service_account.team-dev-us-tfc.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.team-dev-us-tfc.name}/*"
}

resource "google_project_iam_member" "team-dev-us-tfc-project" {
  project = google_project.team-dev-us.name
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.team-dev-us-tfc.email}"
}
