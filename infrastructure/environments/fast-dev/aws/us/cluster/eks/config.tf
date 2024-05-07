data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  network  = data.tfe_outputs.network.values
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-us-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-cluster-eks"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
