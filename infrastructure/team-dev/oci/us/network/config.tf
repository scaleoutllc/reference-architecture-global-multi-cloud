locals {
  provider  = "oci"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "network"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.50.0.0&mask=20&division=9.550
    cidr    = "10.50.0.0/20"
    nodes   = "10.50.0.0/21"
    private = "10.50.8.0/22"
    // unused 10.50.12.0/23
    control_plane = "10.50.14.0/24"
    public        = "10.50.15.0/24"
  }
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
      name    = "oci-team-dev-us-network"
    }
  }
}

provider "oci" {
  region = "us-chicago-1"
  #config_file_profile = "scaleout" # uncomment for local applies
}
