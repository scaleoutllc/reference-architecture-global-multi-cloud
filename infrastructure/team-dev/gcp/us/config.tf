locals {
  provider  = "gcp"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "static"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=5.15.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      name = "gcp-team-dev-us"
    }
  }
}
