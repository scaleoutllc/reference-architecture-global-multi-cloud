resource "oci_core_security_list" "default" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-default"
  vcn_id         = oci_core_vcn.main.id
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
    protocol    = "6"
    destination = local.network.nodes
  }
  ingress_security_rules {
    description = "from nodes"
    protocol    = "6"
    source      = local.network.nodes
  }
  egress_security_rules {
    description      = "to oci services"
    protocol         = "6"
    destination      = data.oci_core_services.all.services[0].cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
  }
  vcn_id = oci_core_vcn.main.id
}

resource "oci_core_security_list" "nodes" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-nodes"
  egress_security_rules {
    description = "to internet"
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  egress_security_rules {
    description = "to other nodes"
    protocol    = "all"
    destination = local.network.nodes
  }
  egress_security_rules {
    description = "to control plane"
    protocol    = "6"
    destination = local.network.control_plane
  }
  ingress_security_rules {
    description = "from other nodes"
    protocol    = "all"
    source      = local.network.nodes
  }
  ingress_security_rules {
    description = "from control plane"
    protocol    = "6"
    source      = local.network.control_plane
  }
  egress_security_rules {
    description      = "to oci services"
    protocol         = "6"
    destination      = data.oci_core_services.all.services[0].cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
  }
  vcn_id = oci_core_vcn.main.id
}
