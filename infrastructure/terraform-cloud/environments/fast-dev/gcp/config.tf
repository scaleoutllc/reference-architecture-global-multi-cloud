locals {
  tfc = {
    hostname = "app.terraform.io"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "terraform-cloud"
      name    = "terraform-cloud-fast-dev-gcp"
    }
  }
}

// Created manually when setting up TFC.
data "tfe_oauth_client" "github" {
  organization     = "scaleout"
  service_provider = "github"
}
