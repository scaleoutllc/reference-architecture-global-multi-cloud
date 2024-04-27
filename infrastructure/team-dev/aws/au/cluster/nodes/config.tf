data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  provider = "aws"
  team     = "team"
  env      = "dev"
  region   = "au"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
  network  = data.tfe_outputs.network.outputs
  cluster  = data.tfe_outputs.cluster.outputs
  routing  = data.tfe_outputs.routing.outputs
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "aws-team-dev-au-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "aws-team-dev-au-cluster-engine"
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "scaleout-platform-routing"
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
      name    = "aws-team-dev-au-cluster-apps"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "au"
}
