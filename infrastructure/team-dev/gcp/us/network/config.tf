locals {
  provider  = "gcp"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "network"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
  // 10.40.0.0/20
  // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.40.0.0&mask=20&division=7.51
  network = {
    cidr = "10.40.12.0/23" // nodes
    ranges = {
      pods     = "10.40.0.0/21"
      services = "10.40.8.0/22"
      private  = "10.40.14.0/23"
    }
  }
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
      project = "gcp-team-dev-us"
      name    = "gcp-team-dev-us-network"
    }
  }
}

provider "google" {
  project = "scaleout-team-dev-us"
  region  = "us-east1"
}
