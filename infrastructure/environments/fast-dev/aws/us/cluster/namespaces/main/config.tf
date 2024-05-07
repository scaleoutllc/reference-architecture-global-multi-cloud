locals {
  team     = "fast"
  env      = "dev"
  provider = "aws"
  region   = "us"
  name     = "${local.team}-${local.env}-${local.provider}-${local.region}"
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "=2.13.1"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-aws-us"
      name    = "fast-dev-aws-us-cluster-namespaces-main"
    }
  }
}

data "aws_eks_cluster" "this_env" {
  name = local.name
}

data "aws_eks_cluster_auth" "this_env" {
  name = local.name
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this_env.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this_env.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this_env.token
  }
}
