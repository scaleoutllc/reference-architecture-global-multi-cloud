resource "google_project" "team-dev-gcp-au" {
  project_id      = "team-dev-gcp-au"
  name            = "team-dev-gcp-au"
  billing_account = "0107CC-5B0989-308B51"
  org_id          = "140123624504"
}

resource "google_project_service" "team-dev-gcp-au" {
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
  project            = google_project.team-dev-gcp-au.name
  service            = each.key
  disable_on_destroy = true
}

resource "google_iam_workload_identity_pool" "tfc-team-dev-gcp-au" {
  project                   = google_project.team-dev-gcp-au.name
  workload_identity_pool_id = "team-dev-gcp-au"
  depends_on                = [google_project_service.team-dev-gcp-au]
}

resource "google_iam_workload_identity_pool_provider" "tfc-team-dev-gcp-au" {
  project                            = google_project.team-dev-gcp-au.name
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc-team-dev-gcp-au.workload_identity_pool_id
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
  attribute_condition = "assertion.sub.startsWith(\"organization:scaleout:project:${google_project.team-dev-gcp-au.name}:workspace:*\")"
}

resource "google_service_account" "tfc-team-dev-gcp-au" {
  project      = google_project.team-dev-gcp-au.name
  account_id   = "tfc-team-dev-gcp-au"
  display_name = "Terraform Cloud Service Account"
  depends_on   = [google_project_service.team-dev-gcp-au]
}

resource "google_service_account_iam_member" "tfc-team-dev-gcp-au" {
  service_account_id = google_service_account.tfc-team-dev-gcp-au.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc-team-dev-gcp-au.name}/*"
}

resource "google_project_iam_member" "tfc-project-team-dev-gcp-au" {
  project = google_project.team-dev-gcp-au.name
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.tfc-team-dev-gcp-au.email}"
}

resource "tfe_project" "team-dev-gcp-au" {
  organization = "scaleout"
  name         = "team-dev-gcp-au"
}

resource "tfe_variable_set" "team-dev-gcp-au" {
  name         = "team-dev-gcp-au"
  organization = "scaleout"
}

resource "tfe_variable" "team-dev-gcp-au" {
  for_each = {
    TFC_GCP_PROVIDER_AUTH             = true
    TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL = google_service_account.tfc-team-dev-gcp-au.email
    TFC_GCP_PROJECT_NUMBER            = google_project.team-dev-gcp-au.number
    TFC_GCP_WORKLOAD_POOL_ID          = google_iam_workload_identity_pool.tfc-team-dev-gcp-au.id
    TFC_GCP_WORKLOAD_PROVIDER_ID      = google_iam_workload_identity_pool_provider.tfc-team-dev-gcp-au.id
  }
  variable_set_id = tfe_variable_set.team-dev-gcp-au.id
  key             = each.key
  value           = each.value
  category        = "env"
}

resource "tfe_project_variable_set" "team-dev-gcp-au" {
  project_id      = tfe_project.team-dev-gcp-au.id
  variable_set_id = tfe_variable_set.team-dev-gcp-au.id
}

resource "tfe_workspace" "team-dev-gcp-au" {
  for_each = toset([
    "network",
    "cluster/gke",
    "cluster/nodes",
    "cluster/namespaces/istio-system",
    "cluster/namespaces/main",
    "routing",
  ])
  name                = "${tfe_project.team-dev-gcp-au.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.team-dev-gcp-au.id
  working_directory   = "infrastructure/team-dev/gcp/au/${each.value}"
  global_remote_state = true
  vcs_repo {
    identifier     = "scaleoutllc/reference-architecture"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
    branch         = "main"
  }
  lifecycle {
    prevent_destroy = false
  }
}
