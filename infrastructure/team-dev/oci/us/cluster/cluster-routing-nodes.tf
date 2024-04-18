resource "oci_core_network_security_group" "lb-to-cluster" {
  compartment_id = local.compartment_id
  display_name   = "${local.envName}-lb-to-cluster"
  vcn_id         = local.network.vcn_id
}

resource "oci_core_network_security_group_security_rule" "lb-to-cluster" {
  network_security_group_id = oci_core_network_security_group.lb-to-cluster.id
  direction                 = "INGRESS"
  protocol                  = 6
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.lb-to-cluster.id
}

resource "oci_core_network_security_group_security_rule" "cluster-to-lb" {
  network_security_group_id = oci_core_network_security_group.lb-to-cluster.id
  direction                 = "EGRESS"
  protocol                  = 6
  destination_type          = "NETWORK_SECURITY_GROUP"
  destination               = oci_core_network_security_group.lb-to-cluster.id
}

resource "oci_containerengine_node_pool" "routing" {
  cluster_id     = oci_containerengine_cluster.main.id
  compartment_id = local.compartment_id
  name           = "${local.envName}-routing"
  initial_node_labels {
    key   = "node.kubernetes.io/node-group"
    value = "${local.envName}-routing"
  }
  initial_node_labels {
    key   = "node.wescaleout.cloud/routing"
    value = "true"
  }
  // https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm
  node_shape = "VM.Standard3.Flex"
  node_shape_config {
    memory_in_gbs = 4
    ocpus         = 1
  }
  node_config_details {
    nsg_ids = [
      oci_core_network_security_group.lb-to-cluster.id
    ]
    node_pool_pod_network_option_details {
      cni_type       = "OCI_VCN_IP_NATIVE"
      pod_subnet_ids = [local.network.nodes_subnet.id]
    }
    // nodes spread across availability domains in single regional subnet.
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.all.availability_domains
      iterator = ad
      content {
        availability_domain = ad.value.name
        subnet_id           = local.network.nodes_subnet.id
      }
    }
    size = 1
  }
  node_source_details {
    source_type = "IMAGE"
    image_id    = local.node_image_x86.image_id
  }
}
