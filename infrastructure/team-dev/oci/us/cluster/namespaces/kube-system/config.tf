locals {
  provider = "oci"
  team     = "team"
  env      = "dev"
  region   = "us"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
  cluster  = data.tfe_outputs.cluster.values
  registry = data.tfe_outputs.registry.values
}

data "tfe_outputs" "registry" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-registry"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-cluster-engine"
}

variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

provider "helm" {
  kubernetes {
    host                   = local.cluster.endpoint
    cluster_ca_certificate = local.cluster.ca-cert
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "${path.module}/../../bin/oci"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster.id]
      env = {
        OCI_CLI_USER        = var.user_ocid
        OCI_CLI_REGION      = "us-chicago-1"
        OCI_CLI_FINGERPRINT = var.fingerprint
        OCI_CLI_TENANCY     = var.tenancy_ocid
        OCI_CLI_KEY_CONTENT = var.private_key
      }
    }
  }
}

provider "kubernetes" {
  host                   = local.cluster.endpoint
  cluster_ca_certificate = local.cluster.ca-cert
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "${path.module}/../../bin/oci"
    args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster.id]
    env = {
      OCI_CLI_USER        = var.user_ocid
      OCI_CLI_REGION      = "us-chicago-1"
      OCI_CLI_FINGERPRINT = var.fingerprint
      OCI_CLI_TENANCY     = var.tenancy_ocid
      OCI_CLI_KEY_CONTENT = var.private_key
    }
  }
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "=2.13.1"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.5"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "oci-team-dev-us"
      name    = "oci-team-dev-us-cluster-namespaces-kube-system"
    }
  }
}

