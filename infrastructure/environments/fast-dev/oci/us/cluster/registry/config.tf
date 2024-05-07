locals {
  team     = "fast"
  env      = "dev"
  provider = "oci"
  region   = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
}

data "oci_identity_tenancy" "this_env" {
  tenancy_id = var.tenancy_ocid
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
      project = "fast-dev-oci-us"
      name    = "fast-dev-oci-us-registry"
    }
  }
}
