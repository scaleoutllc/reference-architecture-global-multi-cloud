data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  provider = "aws"
  team     = "team"
  env      = "dev"
  region   = "au"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
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
      project = "aws-team-dev-au"
      name    = "aws-team-dev-au-cluster-engine"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "au"
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "scaleout-platform-routing"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "aws-team-dev-au-network"
}

locals {
  routing = data.tfe_outputs.routing.outputs
  network = data.tfe_outputs.network.outputs
}
