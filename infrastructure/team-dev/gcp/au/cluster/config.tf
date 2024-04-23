locals {
  provider  = "gcp"
  team      = "team"
  env       = "dev"
  region    = "au"
  workspace = "cluster"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "gcp-team-dev-au"
      name    = "gcp-team-dev-au-cluster"
    }
  }
}

provider "google" {
  project = "scaleout-team-dev-au"
  region  = "australia-southeast1"
}
