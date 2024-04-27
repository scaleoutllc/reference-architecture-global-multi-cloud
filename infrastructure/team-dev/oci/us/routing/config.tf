locals {
  provider = "oci"
  team     = "team"
  env      = "dev"
  region   = "us"
  name     = "${local.provider}-${local.team}-${local.env}-${local.region}"
  tags     = {}
  routing  = data.tfe_outputs.routing.values.oci-us
  network  = data.tfe_outputs.network.values
  nodes    = data.tfe_outputs.cluster.values
  active_nodes = [
    for node in data.oci_containerengine_node_pool.routing.nodes : node if node.state == "ACTIVE"
  ]
}

data "tfe_outputs" "routing" {
  organization = "scaleout"
  workspace    = "scaleout-platform-team-dev-routing"
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-network"
}

data "tfe_outputs" "nodes" {
  organization = "scaleout"
  workspace    = "oci-team-dev-us-cluster-nodes"
}

// TODO: either use k8s load balancer services for ingress, address the
// lack of ability to target a node pool with a network load balancer or
// accept that rotating routing nodes will require some kind of integration
// with this workspace.
data "oci_containerengine_node_pool" "routing" {
  node_pool_id = local.nodes.routing-node-pool-id
}

provider "oci" {
  region       = "us-chicago-1"
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "aws" {
  region  = "us-east-1"
  profile = "us"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.45"
    }
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "oci-team-dev-us"
      name    = "oci-team-dev-us-routing"
    }
  }
}
