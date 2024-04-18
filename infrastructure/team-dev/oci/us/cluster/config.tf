locals {
  provider       = "oci"
  team           = "team"
  env            = "dev"
  region         = "us"
  workspace      = "cluster"
  envName        = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name           = "${local.envName}-${local.workspace}"
  tags           = {}
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
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
      name    = "oci-team-dev-us-cluster"
    }
  }
}

provider "oci" {
  region              = "us-chicago-1"
  config_file_profile = "scaleout"
}

data "oci_identity_availability_domains" "all" {
  compartment_id = local.compartment_id
}
