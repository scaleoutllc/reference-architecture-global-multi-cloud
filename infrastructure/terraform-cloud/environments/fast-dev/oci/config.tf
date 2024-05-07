locals {
  fast-dev-oci-us = {
    tenancy_id     = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
    admin_group_id = "ocid1.group.oc1..aaaaaaaaoovxzrfd2dnffczohw4hedwdcw5tikv2tbq55ow2xlnmysvh3nza"
    region         = "us-chicago-1"
  }
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "5.38.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "terraform-cloud"
      name    = "terraform-cloud-fast-dev-oci"
    }
  }
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

// Created manually when setting up TFC.
data "tfe_oauth_client" "github" {
  organization     = "scaleout"
  service_provider = "github"
}
