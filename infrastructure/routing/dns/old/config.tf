locals {
  domain = "fast.dev.wescaleout.cloud"
  deployments = {
    "us" = [
      {
        provider = "aws"
        region   = "us-east-1"
      },
      {
        provider = "gcp",
        region   = "us-east1"
      },
      {
        provider = "oci",
        region   = "us-chicago-1"
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
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "=2.21.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "platform"
      name    = "platform-routing"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "au"
}

provider "google" {
  project = "fast-dev-gcp-us"
  region  = "us-east1"
  alias   = "us"
}

provider "google" {
  project = "fast-dev-gcp-au"
  region  = "australia-southeast1"
  alias   = "au"
}

provider "oci" {
  region              = "us-chicago-1"
  config_file_profile = "scaleout"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "platform-routing"
}

locals {
  routing = data.tfe_outputs.routing.values
}
