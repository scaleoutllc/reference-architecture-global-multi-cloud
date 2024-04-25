data "aws_region" "this_env" {}
data "aws_caller_identity" "this_env" {}

locals {
  provider  = "aws"
  team      = "team"
  env       = "dev"
  region    = "global"
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
      project = "aws-team-dev-global"
      name    = "aws-team-dev-global-routing"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}

