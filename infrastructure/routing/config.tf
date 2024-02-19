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
