data "aws_region" "this_env" {}

locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.10.0.0&mask=20&division=13.3d40
    cidr            = "10.10.0.0/20"
    private_subnets = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"],
    public_subnets  = ["10.10.12.0/24", "10.10.13.0/24", "10.10.14.0/24"]
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-network"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
