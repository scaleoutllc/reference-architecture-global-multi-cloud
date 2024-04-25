locals {
  provider  = "oci"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "cluster-config"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
}

terraform {
  required_providers {
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
      project = "oci-team-dev-us"
      name    = "oci-team-dev-us-cluster-config"
    }
  }
}

provider "kubectl" {
  host     = local.cluster.endpoint
  insecure = true // could not find CA cert in attributes of any resource
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "${path.module}/bin/oci"
    args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster.id]
  }
}

provider "helm" {
  kubernetes {
    host     = local.cluster.endpoint
    insecure = true // could not find CA cert in attributes of any resource
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "${path.module}/bin/oci"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster.id]
    }
  }
}
