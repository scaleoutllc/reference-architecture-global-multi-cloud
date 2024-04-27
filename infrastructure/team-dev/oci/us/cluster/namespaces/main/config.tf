locals {
  provider = "oci"
  team     = "team"
  env      = "dev"
  region   = "us"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
  cluster  = data.tfe_outputs.cluster.values
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-cluster-engine"
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
      project = "oci-team-dev-us"
      name    = "oci-team-dev-us-cluster-namespaces-main"
    }
  }
}

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "helm" {
  kubernetes {
    host     = local.cluster.endpoint
    insecure = true // could not find CA cert in attributes of any resource
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
