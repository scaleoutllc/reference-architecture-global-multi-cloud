output "vcn_id" {
  value = oci_core_vcn.main.id
}

output "public_subnets" {
  value = oci_core_subnet.public[*].id
}

output "private_subnets" {
  value = oci_core_subnet.private[*].id
}

output "public_subnets_cidr_blocks" {
  value = oci_core_subnet.public[*].cidr_block
}

output "private_subnets_cidr_blocks" {
  value = oci_core_subnet.private[*].cidr_block
}
