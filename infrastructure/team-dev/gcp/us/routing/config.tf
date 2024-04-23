locals {
  provider  = "gcp"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "routing"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.46"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "gcp-team-dev-us"
      name    = "gcp-team-dev-us-routing"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}

provider "google" {
  project = "scaleout-team-dev-us"
  region  = "us-east1"
}
