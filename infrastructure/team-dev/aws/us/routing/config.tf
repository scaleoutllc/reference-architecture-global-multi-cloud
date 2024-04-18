locals {
  provider  = "aws"
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
      version = "=5.45"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "aws-team-dev-us"
      name    = "aws-team-dev-us-routing"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}
