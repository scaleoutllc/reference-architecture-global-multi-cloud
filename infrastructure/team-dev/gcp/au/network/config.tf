locals {
  provider  = "gcp"
  team      = "team"
  env       = "dev"
  region    = "au"
  workspace = "network"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
  // 10.30.0.0/20
  // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.30.0.0&mask=20&division=7.51
  network = {
    cidr = "10.30.12.0/23" // nodes
    ranges = {
      pods     = "10.30.0.0/21"
      services = "10.30.8.0/22"
      private  = "10.30.14.0/23"
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
      project = "gcp-team-dev-au"
      name    = "gcp-team-dev-au-network"
    }
  }
}

provider "google" {
  project = "scaleout-team-dev-au"
  region  = "australia-southeast1"
}
