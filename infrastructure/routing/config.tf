locals {
  cloudflare_account_id = "cf4f1115f41603efc5b82fcc4d3c2028"
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.24.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "=5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "=5.15.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      name = "routing"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {}

provider "aws" {
  region = "us-east-1"
}

/*
team.dev.wescaleout.cloud
team.dev.us.wescaleout.cloud
team.dev.aws.wescaleout.cloud
team.dev.aws.us.wescaleout.cloud

-> common lowest, strip = wescaleout.cloud


team.dev
team.dev.us
team.dev.aws
team.dev.aws.us

invert?

dev.team
us.dev.team
aws.dev.team
us.dev.


wescaleout.cloud
  dev.wescaleout.cloud
    team.dev.wescaleout.cloud
  us.wescaleout.cloud
    dev.us.wescaleout.cloud
      team.dev.us.wescaleout.cloud
    aws.us.wescaleout.cloud
      dev.aws.us.wescaleout.cloud
        team.dev.aws.us.wescaleout.cloud
  aws.wescaleout.cloud
    dev.aws.wescaleout.cloud
      team.dev.aws.wescaleout.cloud
*/
