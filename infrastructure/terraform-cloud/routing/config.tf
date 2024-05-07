terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "terraform-cloud"
      name    = "terraform-cloud-platform"
    }
  }
}

// Created manually when setting up TFC.
data "tfe_oauth_client" "github" {
  organization     = "scaleout"
  service_provider = "github"
}

resource "tfe_project" "routing" {
  organization = "scaleout"
  name         = "routing"
}
