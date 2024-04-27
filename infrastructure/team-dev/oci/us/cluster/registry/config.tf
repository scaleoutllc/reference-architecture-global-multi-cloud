locals {
  provider = "oci"
  team     = "team"
  env      = "dev"
  region   = "us"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
  routing  = data.tfe_outputs.routing.values.oci-us
  network  = data.tfe_outputs.network.values
  cluster  = data.tfe_outputs.cluster.values
}

data "oci_identity_tenancy" "this_env" {
  tenancy_id = var.tenancy_ocid
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "scaleout-platform-team-dev-routing"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-cluster"
}

variable "tenancy_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "oci" {
  region       = "us-chicago-1"
  tenancy_ocid = var.tenancy_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "oci-team-dev-us"
      name    = "oci-team-dev-us-registry"
    }
  }
}
