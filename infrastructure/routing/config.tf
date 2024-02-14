locals {
  domain = "wescaleout.online"
  environments = [
    "demo-dev-aws-us",
    "demo-dev-aws-au",
    "demo-prod-aws-us",
    "demo-prod-aws-au"
  ]
  sans = [
    for name in local.environments : {
      name     = name
      area     = split("-", name)[0]
      env      = split("-", name)[1]
      provider = split("-", name)[2]
      region   = split("-", name)[3]
      sans = split("\n", templatefile("${path.module}/templates/${split("-", name)[1]}-sans.tpl", {
        area     = split("-", name)[0]
        env      = split("-", name)[1]
        provider = split("-", name)[2]
        region   = split("-", name)[3]
        domain   = local.domain
      }))
    }
  ]
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
  backend "s3" {
    bucket  = "scaleout-platform"
    key     = "dns"
    profile = "scaleout-platform"
    region  = "us-east-1"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  profile = "scaleout-platform"
}

variable "cloudflare_api_token" {}
