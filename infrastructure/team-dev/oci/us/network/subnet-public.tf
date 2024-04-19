resource "oci_core_subnet" "public" {
  cidr_block                 = local.network.public
  compartment_id             = local.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  display_name               = "${local.name}-public"
  route_table_id             = oci_core_default_route_table.public.id
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  // use our own security list, OCI default allows SSH traffic from anywhere
  security_list_ids = [
    oci_core_security_list.oci-core-services.id,
    oci_core_security_list.public.id
  ]
}

// TODO: remove this as security lists will be deprecated.
resource "oci_core_security_list" "public" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-public"
  vcn_id         = oci_core_vcn.main.id
  egress_security_rules {
    description = "to world"
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    description = "from world"
    protocol    = "all"
    source      = "0.0.0.0/0"
  }
}
