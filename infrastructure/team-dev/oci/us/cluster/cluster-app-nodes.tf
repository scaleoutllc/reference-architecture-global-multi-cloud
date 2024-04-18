resource "oci_containerengine_node_pool" "apps" {
  cluster_id     = oci_containerengine_cluster.main.id
  compartment_id = local.compartment_id
  name           = "${local.envName}-apps"
  initial_node_labels {
    key   = "node.kubernetes.io/node-group"
    value = "${local.envName}-apps"
  }
  initial_node_labels {
    key   = "node.wescaleout.cloud/apps"
    value = "true"
  }
  // https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm
  node_shape = "VM.Standard3.Flex"
  node_shape_config {
    memory_in_gbs = 4
    ocpus         = 1
  }
  node_config_details {
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
