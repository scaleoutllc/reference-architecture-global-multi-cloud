locals {
  tfc = {
    hostname = "app.terraform.io"
    audience = "aws.workload.identity"
  }
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
  // this block should be commented out for the very first apply
  cloud {
    organization = "scaleout"
    workspaces {
      project = "scaleout-platform"
      name    = "scaleout-platform-gcp-bootstrap"
    }
  }
}

