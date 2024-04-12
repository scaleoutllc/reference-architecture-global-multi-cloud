resource "google_project" "team-dev-au" {
  project_id      = "scaleout-team-dev-au"
  name            = "scaleout-team-dev-au"
  billing_account = "0107CC-5B0989-308B51"
  org_id          = "140123624504"
}

resource "google_project_service" "team-dev-au" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
    "dns.googleapis.com",
    "certificatemanager.googleapis.com",
  ])
  project            = google_project.team-dev-au.name
  service            = each.key
  disable_on_destroy = true
}

resource "google_iam_workload_identity_pool" "team-dev-au-tfc" {
  project                   = google_project.team-dev-au.name
  workload_identity_pool_id = "scaleout-team-dev-au"
  depends_on                = [google_project_service.team-dev-au]
}

resource "google_iam_workload_identity_pool_provider" "team-dev-au-tfc" {
  project                            = google_project.team-dev-au.name
  workload_identity_pool_id          = google_iam_workload_identity_pool.team-dev-au-tfc.workload_identity_pool_id
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
  attribute_condition = "assertion.sub.startsWith(\"organization:scaleout:project:${google_project.team-dev-au.name}:workspace:*\")"
}

resource "google_service_account" "team-dev-au-tfc" {
  project      = google_project.team-dev-au.name
  account_id   = "tfc-team-dev-au-sa"
  display_name = "Terraform Cloud Service Account"
  depends_on   = [google_project_service.team-dev-au]
}

resource "google_service_account_iam_member" "team-dev-au-tfc" {
  service_account_id = google_service_account.team-dev-au-tfc.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.team-dev-au-tfc.name}/*"
}

resource "google_project_iam_member" "team-dev-au-tfc-project" {
  project = google_project.team-dev-au.name
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.team-dev-au-tfc.email}"
}
