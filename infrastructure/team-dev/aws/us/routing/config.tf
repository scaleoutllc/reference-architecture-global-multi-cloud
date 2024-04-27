locals {
  provider = "aws"
  team     = "team"
  env      = "dev"
  region   = "us"
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
      project = "aws-team-dev-us"
      name    = "aws-team-dev-us-routing"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "scaleout-platform-team-dev-routing"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "aws-team-dev-us-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "aws-team-dev-us-cluster-engine"
}

locals {
  routing = data.tfe_outputs.routing.values.aws-us
  network = data.tfe_outputs.network.values
  cluster = data.tfe_outputs.cluster.values
}
