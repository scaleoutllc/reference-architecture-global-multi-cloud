data "aws_region" "this_env" {}

locals {
  provider  = "aws"
  team      = "team"
  env       = "dev"
  region    = "au"
  workspace = "network"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
  tags      = {}
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.0.0.0&mask=20&division=13.3d40
    cidr            = "10.0.0.0/20"
    private_subnets = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"],
    public_subnets  = ["10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]
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
      project = "aws-team-dev-au"
      name    = "aws-team-dev-au-network"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "au"
}
