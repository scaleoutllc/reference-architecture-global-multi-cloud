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
