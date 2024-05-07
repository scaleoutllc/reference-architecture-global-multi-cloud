locals {
  team     = "fast"
  env      = "dev"
  provider = "oci"
  region   = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  cluster  = data.tfe_outputs.cluster.values
  registry = data.tfe_outputs.registry.values
}

data "tfe_outputs" "registry" {
  organization = "scaleout"
  workspace    = "fast-dev-oci-us-registry"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-oci-us-cluster-oke"
}

variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "helm" {
  kubernetes {
    host                   = local.cluster.endpoint
    cluster_ca_certificate = local.cluster.ca-cert
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "${path.module}/../../bin/oci"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster.id]
      env = {
        OCI_CLI_REGION      = var.region
        OCI_CLI_TENANCY     = var.tenancy_ocid
        OCI_CLI_USER        = var.user_ocid
        OCI_CLI_FINGERPRINT = var.fingerprint
        OCI_CLI_KEY_CONTENT = var.private_key
      }
    }
  }
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "=2.13.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-oci-us"
      name    = "fast-dev-oci-us-cluster-namespaces-kube-system"
    }
  }
}

