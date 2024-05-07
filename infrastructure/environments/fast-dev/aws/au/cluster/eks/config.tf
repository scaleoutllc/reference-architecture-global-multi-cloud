data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  network  = data.tfe_outputs.network.values
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-aws-au-network"
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-cluster-eks"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
