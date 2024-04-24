locals {
  team-dev-us = {
    tenancy_id     = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
    admin_group_id = "ocid1.group.oc1..aaaaaaaaoovxzrfd2dnffczohw4hedwdcw5tikv2tbq55ow2xlnmysvh3nza"
  }
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "5.38.0"
    }
  }
}

provider "oci" {
  region              = "us-chicago-1"
  config_file_profile = "scaleout"
}
