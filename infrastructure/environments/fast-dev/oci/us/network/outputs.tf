output "vcn_id" {
  value = oci_core_vcn.main.id
}

output "nodes_subnet" {
  value = oci_core_subnet.nodes
}

output "control_plane_subnet" {
  value = oci_core_subnet.control-plane
}

output "private_subnet" {
  value = oci_core_subnet.private
}

output "public_subnet" {
  value = oci_core_subnet.public
}

output "internal_ingress_security_group_id" {
  value = oci_core_network_security_group.internal-ingress.id
}

output "control_plane_security_group_id" {
  value = oci_core_network_security_group.control-plane.id
}

output "pod_security_group_id" {
  value = oci_core_network_security_group.pod.id
}

output "node_security_group_id" {
  value = oci_core_network_security_group.node.id
}
