resource "oci_core_subnet" "private" {
  cidr_block                 = local.network.private
  compartment_id             = local.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  display_name               = "${local.name}-private"
  route_table_id             = oci_core_route_table.private.id
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  // use our own security list, OCI default allows SSH traffic from anywhere
  security_list_ids = [
    oci_core_security_list.oci-core-services.id,
  ]
}
