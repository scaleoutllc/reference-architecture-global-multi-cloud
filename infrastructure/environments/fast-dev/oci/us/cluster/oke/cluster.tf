resource "oci_containerengine_cluster" "main" {
  compartment_id     = var.compartment_id
  kubernetes_version = "v${local.k8s_version}"
  name               = local.name
  vcn_id             = local.network.vcn_id
  type               = "ENHANCED_CLUSTER"
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  endpoint_config {
    is_public_ip_enabled = "true"
    subnet_id            = local.network.control_plane_subnet.id
    nsg_ids = [
      local.network.control_plane_security_group_id
    ]
  }
}
