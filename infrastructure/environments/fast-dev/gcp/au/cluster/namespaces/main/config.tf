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
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "=2.13.1"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-gcp-au"
      name    = "fast-dev-gcp-au-cluster-namespaces-main"
    }
  }
}


provider "helm" {
  kubernetes {
    host                   = local.cluster.endpoint
    cluster_ca_certificate = local.cluster.ca-cert
    token                  = local.cluster.token
  }
}
