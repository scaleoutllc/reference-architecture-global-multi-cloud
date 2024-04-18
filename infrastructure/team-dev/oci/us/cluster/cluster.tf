data "oci_containerengine_node_pool_option" "oke" {
  node_pool_option_id = "all"
  compartment_id      = local.compartment_id
}

locals {
  cluster_k8s_version  = "1.27.2"
  node_k8s_version     = "1.27.2"
  node_image_x86_regex = "Oracle-Linux-8.9-\\d{4}.\\d{2}.\\d{2}-\\d{1}-OKE-${local.node_k8s_version}"
  node_image_x86 = element([
    for item in data.oci_containerengine_node_pool_option.oke.sources :
    item if can(regex(local.node_image_x86_regex, item.source_name))
  ], 0)
}

resource "oci_containerengine_cluster" "main" {
  compartment_id     = local.compartment_id
  kubernetes_version = "v${local.cluster_k8s_version}"
  name               = local.envName
  vcn_id             = local.network.vcn_id
  type               = "ENHANCED_CLUSTER"
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  endpoint_config {
    is_public_ip_enabled = "true"
    subnet_id            = local.network.control_plane_subnet.id
  }
}
