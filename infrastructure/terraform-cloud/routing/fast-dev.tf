resource "tfe_workspace" "routing-fast-dev" {
  for_each = toset([
    "fast-dev/global",
    "fast-dev/provider/aws",
    "fast-dev/provider/gcp",
    "fast-dev/provider/oci",
    "fast-dev/regional/au",
    "fast-dev/regional/us",
  ])
  name                = "${tfe_project.routing.name}-${replace(each.value, "/", "-")}"
  organization        = "scaleout"
  project_id          = tfe_project.routing.id
  working_directory   = "infrastructure/routing/north-south/${each.value}"
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
