locals {
  team     = "fast"
  env      = "dev"
  provider = "oci"
  region   = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.50.0.0&mask=20&division=9.550
    cidr    = "10.50.0.0/20"
    nodes   = "10.50.0.0/21"
    private = "10.50.8.0/22"
    // unused 10.50.12.0/23
    control_plane = "10.50.14.0/24"
    public        = "10.50.15.0/24"
  }
}

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "oci" {
  region       = "us-chicago-1"
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
      name    = "fast-dev-oci-us-network"
    }
  }
}
