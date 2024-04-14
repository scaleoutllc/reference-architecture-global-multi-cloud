data "aws_eks_cluster" "this_env" {
  name = local.envName
}

data "aws_eks_cluster_auth" "this_env" {
  name = local.envName
}

locals {
  provider  = "aws"
  team      = "team"
  env       = "dev"
  region    = "au"
  workspace = "cluster-config"
  envName   = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name      = "${local.envName}-${local.workspace}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.45"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "=1.14.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "aws-team-dev-au"
      name    = "aws-team-dev-au-cluster-config"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.this_env.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this_env.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this_env.token
}
