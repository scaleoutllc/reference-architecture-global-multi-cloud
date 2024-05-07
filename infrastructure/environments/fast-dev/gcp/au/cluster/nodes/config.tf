locals {
  team     = "fast"
  env      = "dev"
  provider = "gcp"
  region   = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  cluster  = data.tfe_outputs.cluster.values
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-gcp-au-cluster-gke"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-nodes"
    }
  }
}

provider "google" {
  project = "fast-dev-gcp-au"
  region  = "australia-southeast1"
}
