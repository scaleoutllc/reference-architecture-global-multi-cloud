terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.0"
    }
  }
  // the "cloud" block should be commented out for the very first apply
  cloud {
    organization = "scaleout"
    workspaces {
      name = "aws-bootstrap"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
