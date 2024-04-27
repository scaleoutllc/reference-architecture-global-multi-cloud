data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  provider = "aws"
  team     = "team"
  env      = "dev"
  region   = "us"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
  routing  = data.tfe_outputs.routing.values
  network  = data.tfe_outputs.network.values
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "scaleout-platform-routing"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "aws-team-dev-us-network"
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
      name    = "aws-team-dev-us-cluster-nodes"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}
