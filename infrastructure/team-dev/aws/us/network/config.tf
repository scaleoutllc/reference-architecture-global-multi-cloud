data "aws_region" "this_env" {}

locals {
  provider  = "aws"
  team      = "team"
  env       = "dev"
  region    = "us"
  workspace = "network"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.10.0.0&mask=20&division=13.3d40
    cidr            = "10.10.0.0/20"
    private_subnets = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"],
    public_subnets  = ["10.10.12.0/24", "10.10.13.0/24", "10.10.14.0/24"]
  }
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
      name    = "aws-team-dev-us-network"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}
