resource "oci_core_subnet" "control-plane" {
  cidr_block                 = local.network.control_plane
  compartment_id             = local.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  display_name               = "${local.name}-control-plane"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.public.id
  security_list_ids = [
    oci_core_security_list.oci-core-services.id,
    oci_core_security_list.control-plane.id
  ]
}

resource "oci_core_security_list" "control-plane" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-control-plane"
  ingress_security_rules {
    description = "from world / operators"
    protocol    = "6"
    source      = "0.0.0.0/0"
  }
  egress_security_rules {
    description = "to nodes"
    protocol    = "all"
    destination = local.network.nodes
  }
  vcn_id = oci_core_vcn.main.id
}
