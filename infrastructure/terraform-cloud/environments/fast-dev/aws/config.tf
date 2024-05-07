locals {
  tfc = {
    hostname = "app.terraform.io"
    audience = "aws.workload.identity"
  }
}

terraform {
  cloud {
    organization = "scaleout"
    workspaces {
      project = "terraform-cloud"
      name    = "terraform-cloud-fast-dev-aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "tls_certificate" "tfc" {
  url = "https://${local.tfc.hostname}"
}

resource "aws_iam_openid_connect_provider" "tfc" {
  url             = data.tls_certificate.tfc.url
  client_id_list  = [local.tfc.audience]
  thumbprint_list = [data.tls_certificate.tfc.certificates[0].sha1_fingerprint]
}

// Created manually when setting up TFC.
data "tfe_oauth_client" "github" {
  organization     = "scaleout"
  service_provider = "github"
}
