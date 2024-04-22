resource "oci_containerengine_node_pool" "system" {
  cluster_id     = oci_containerengine_cluster.main.id
  compartment_id = local.compartment_id
  name           = "${local.envName}-system"
  initial_node_labels {
    key   = "node.kubernetes.io/node-group"
    value = "${local.envName}-system"
  }
  initial_node_labels {
    key   = "node.wescaleout.cloud/system"
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
        local.network.nodes_subnet.id
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
  // add taints
  // https://blogs.oracle.com/cloud-infrastructure/post/container-engine-for-kubernetes-custom-worker-node-startup-script-support
  // https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingcustomcloudinitscripts.htm
  // TODO: support istio? https://github.com/istio/istio/issues/44118
  node_metadata = {
    user_data = base64encode(<<-EOT
      #!/bin/bash
      export KUBELET_EXTRA_ARGS="--register-with-taints=node.wescaleout.cloud/routing=true:NoSchedule"
      curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode > /var/run/oke-init.sh
      bash /var/run/oke-init.sh
      EOT
    )
  }
}
