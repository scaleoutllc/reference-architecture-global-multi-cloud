terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=5.15.0"
    }
  }
  // this block should be commented out for the very first apply
  cloud {
    organization = "scaleout"
    workspaces {
      name = "gcp-bootstrap"
    }
  }
}

