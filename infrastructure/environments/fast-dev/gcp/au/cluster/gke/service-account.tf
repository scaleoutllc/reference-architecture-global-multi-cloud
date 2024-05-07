
resource "google_service_account" "nodes" {
  account_id = local.name
}

resource "google_project_iam_member" "nodes-log-writer" {
  project = "fast-dev-gcp-au"
  role    = "roles/logging.logWriter"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-metric-writer" {
  project = "fast-dev-gcp-au"
  role    = "roles/monitoring.metricWriter"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-monitoring-viewer" {
  project = "fast-dev-gcp-au"
  role    = "roles/monitoring.viewer"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-resource-metadata-writer" {
  project = "fast-dev-gcp-au"
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-gcr" {
  project = "fast-dev-gcp-au"
  role    = "roles/storage.objectViewer"
  member  = google_service_account.nodes.member
}

resource "google_project_iam_member" "nodes-artifact-registry" {
  project = "fast-dev-gcp-au"
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.nodes.member
  //TODO: scope to specific registry?
}
