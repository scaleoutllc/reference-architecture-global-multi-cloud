data "google_client_config" "current" {}
data "google_container_cluster" "this_env" {
  name = local.envName
}

locals {
  provider  = "gcp"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "cluster-config"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "=1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=2.13.1"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "gcp-team-dev-us"
      name    = "gcp-team-dev-us-cluster-config"
    }
  }
}

provider "google" {
  project = "scaleout-team-dev-us"
  region  = "us-east1"
}

provider "kubectl" {
  host                   = data.google_container_cluster.this_env.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.this_env.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.this_env.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.this_env.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}
