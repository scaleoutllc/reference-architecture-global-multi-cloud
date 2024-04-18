resource "oci_core_subnet" "nodes" {
  cidr_block                 = local.network.nodes
  compartment_id             = local.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  display_name               = "${local.name}-pods"
  route_table_id             = oci_core_route_table.private.id
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  // use our own security list, OCI default allows SSH traffic from anywhere
  security_list_ids = [
    oci_core_security_list.oci-core-services.id,
    oci_core_security_list.nodes.id
  ]
}

resource "oci_core_security_list" "nodes" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-nodes"
  egress_security_rules {
    description = "to world"
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    description = "from other nodes"
    protocol    = "all"
    source      = local.network.nodes
  }
  ingress_security_rules {
    description = "from control plane"
    protocol    = "all"
    source      = local.network.control_plane
  }
  vcn_id = oci_core_vcn.main.id
}
