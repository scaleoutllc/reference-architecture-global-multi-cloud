data "aws_region" "this_env" {}

locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "au"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
  network = {
    // https://www.davidc.net/sites/default/subnets/subnets.html?network=10.20.0.0&mask=20&division=13.3d40
    cidr            = "10.20.0.0/20"
    private_subnets = ["10.20.0.0/22", "10.20.4.0/22", "10.20.8.0/22"],
    public_subnets  = ["10.20.12.0/24", "10.20.13.0/24", "10.20.14.0/24"]
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-au"
      name    = "fast-dev-aws-au-network"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
