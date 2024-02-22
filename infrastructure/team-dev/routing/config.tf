terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.0"
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
  region = "us-east-1"
}
