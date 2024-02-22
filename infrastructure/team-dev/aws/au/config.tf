locals {
  provider  = "aws"
  team      = "team"
  env       = "dev"
  region    = "au"
  workspace = "static"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      name = "aws-team-dev-au"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
