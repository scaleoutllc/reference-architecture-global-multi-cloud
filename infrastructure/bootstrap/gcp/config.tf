locals {
  tfc = {
    hostname = "app.terraform.io"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "scaleout-platform"
      name    = "scaleout-platform-bootstrap-gcp"
    }
  }
}

data "tfe_oauth_client" "github" {
  organization     = "scaleout"
  service_provider = "github"
}
