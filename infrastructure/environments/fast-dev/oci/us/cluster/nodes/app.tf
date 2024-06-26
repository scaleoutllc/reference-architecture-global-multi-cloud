resource "oci_containerengine_node_pool" "app" {
  cluster_id     = local.cluster.id
  compartment_id = var.compartment_id
  name           = "${local.name}-app"
  initial_node_labels {
    key   = "node.wescaleout.cloud/node-group"
    value = "${local.name}-app"
  }
  initial_node_labels {
    key   = "node.wescaleout.cloud/app"
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
      local.network.node_security_group_id
    ]
    node_pool_pod_network_option_details {
      cni_type = "OCI_VCN_IP_NATIVE"
      pod_subnet_ids = [
        local.network.public_subnet.id
      ]
      pod_nsg_ids = [
        local.network.pod_security_group_id
      ]
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
    size = 2
  }
  node_source_details {
    source_type = "IMAGE"
    image_id    = local.node_image_x86.image_id
  }
  node_metadata = {
    user_data = base64encode(<<EOF
#!/bin/bash
export KUBELET_EXTRA_ARGS="--register-with-taints=node.wescaleout.cloud/app=true:NoSchedule"
${local.init.nossh}
${local.init.istio}
${local.init.kubelet}
EOF
    )
  }
}
