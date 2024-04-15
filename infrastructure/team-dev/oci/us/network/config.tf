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
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.50.0.0&mask=20&division=13.3d40
    cidr            = "10.50.0.0/20"
    private_subnets = ["10.50.0.0/22", "10.50.4.0/22", "10.50.8.0/22"],
    public_subnets  = ["10.50.12.0/24", "10.50.13.0/24", "10.50.14.0/24"]
  }
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "5.37.0"
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
  region              = "us-chicago-1"
  config_file_profile = "scaleout"
}
