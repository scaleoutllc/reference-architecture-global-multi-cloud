locals {
  provider             = "oci"
  team                 = "fast"
  env                  = "dev"
  region               = "us"
  name                 = "${local.team}-${local.env}-${local.provider}-${local.region}"
  tags                 = {}
  k8s_version          = "1.28.2"
  node_image_x86_regex = "Oracle-Linux-8.9-\\d{4}.\\d{2}.\\d{2}-\\d{1}-OKE-${local.k8s_version}"
  node_image_x86 = element([
    for item in data.oci_containerengine_node_pool_option.oke.sources :
    item if can(regex(local.node_image_x86_regex, item.source_name))
  ], 0)
  network = data.tfe_outputs.network.values
  cluster = data.tfe_outputs.cluster.values
  init = {
    # disable SSH into nodes.
    nossh = "rm -rf /home/opc/.ssh && systemctl stop sshd"
    # required for istio sidecars to run
    istio = "modprobe ip_tables"
    # required to join cluster / allow overriding KUBELET_EXTRA_ARGS
    kubelet = <<EOF
curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode > /var/run/oke-init.sh
bash /var/run/oke-init.sh
EOF
  }
}

data "oci_containerengine_node_pool_option" "oke" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

data "tfe_outputs" "network" {
  organization = "scaleout"
  workspace    = "fast-dev-oci-us-network"
}

data "tfe_outputs" "cluster" {
  organization = "scaleout"
  workspace    = "fast-dev-oci-us-cluster-oke"
}

data "oci_identity_availability_domains" "all" {
  compartment_id = var.compartment_id
}

variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
variable "compartment_id" {}

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
  }
  cloud {
    organization = "scaleout"
    workspaces {
      project = "fast-dev-oci-us"
      name    = "fast-dev-oci-us-cluster-nodes"
    }
  }
}
