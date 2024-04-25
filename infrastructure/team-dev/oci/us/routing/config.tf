locals {
  provider       = "oci"
  team           = "team"
  env            = "dev"
  region         = "us"
  workspace      = "routing"
  envName        = "${local.provider}-${local.team}-${local.env}-${local.region}"
  name           = "${local.envName}-${local.workspace}"
  tags           = {}
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaqmdyo455h7pgzmgvsn5ue4dg73oxhp47udjc66c3vlg5h7wyzvsa"
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

provider "oci" {
  region              = "us-chicago-1"
  config_file_profile = "scaleout" # uncomment for local applies
  #private_key = base64decode(var.oci_private_key) # comment for local applies
}

#variable "oci_private_key" {} # comment for local applies

provider "aws" {
  region = "us-east-1"
}

// TODO: either use k8s load balancer services for ingress, address the
// lack of ability to target a node pool with a network load balancer or
// accept that rotating routing nodes will require some kind of integration
// with this workspace.
data "oci_containerengine_node_pool" "routing" {
  node_pool_id = local.cluster.routing-node-pool-id
}
locals {
  active_nodes = [
    for node in data.oci_containerengine_node_pool.routing.nodes : node if node.state == "ACTIVE"
  ]
}
