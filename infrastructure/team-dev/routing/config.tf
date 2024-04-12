locals {
  domain = "team.dev.wescaleout.cloud"
  deployments = {
    "us" = [
      {
        provider = "aws"
        region   = "us-east-1"
      },
      {
        provider = "gcp",
        region   = "us-east1"
      }
    ],
    "au" = [
      {
        provider = "aws"
        region   = "ap-southeast-2"
      },
      {
        provider = "gcp",
        region   = "australia-southeast1"
      }
    ]
  }
  providers = toset(flatten([
    for region in local.deployments : [
      for item in region : item.provider
    ]
  ]))
  regions = toset(keys(local.deployments))
  fully-specified = toset([
    for env in setproduct(local.providers, local.regions) : join("-", env)
  ])
  sans = merge(flatten([
    for region, environments in local.deployments : [{
      for item in environments : "${item.provider}-${region}" => [
        local.domain,
        "*.${local.domain}",
        "*.${item.provider}.${local.domain}",
        "*.${region}.${local.domain}",
        "*.${item.provider}-${region}.${local.domain}"
      ]
    }]
  ])...)
  zones = merge(
    { for key, zone in aws_route53_zone.provider : "${zone.name}" => zone.id },
    { for key, zone in aws_route53_zone.region : "${zone.name}" => zone.id },
    { for key, zone in aws_route53_zone.fully-specified : "${zone.name}" => zone.id }
  )
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.45"
    }
    google = {
      source  = "hashicorp/google"
      version = "=5.24"

    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      name = "team-dev-routing"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "au"
  alias   = "au"
}

provider "google" {
  project = "scaleout-team-dev-us"
  region  = "us-east1"
  alias   = "us"
}

provider "google" {
  project = "scaleout-team-dev-au"
  region  = "australia-southeast1"
  alias   = "au"
}
