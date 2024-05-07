locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  network  = data.tfe_outputs.network.values
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-au-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-gke"
    }
  }
}

provider "google" {
  project = "fast-dev-gcp-au"
  region  = "australia-southeast1"
}
