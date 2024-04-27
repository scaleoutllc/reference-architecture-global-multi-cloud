resource "oci_core_subnet" "control-plane" {
  cidr_block                 = local.network.control_plane
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  display_name               = "${local.name}-control-plane"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.public.id
  security_list_ids = [
    oci_core_security_list.oci-core-services.id
  ]
}

resource "oci_core_network_security_group" "control-plane" {
  compartment_id = var.compartment_id
  display_name   = "${local.name}-control-plane"
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_network_security_group_security_rule" "world-ingress-control-plane" {
  description               = "let world / operators reach control plane"
  network_security_group_id = oci_core_network_security_group.control-plane.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "control-plane-egress-world" {
  description               = "let control plane reach the world"
  network_security_group_id = oci_core_network_security_group.control-plane.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "nodes-ingress-control-plane" {
  description               = "let nodes reach control plane"
  network_security_group_id = oci_core_network_security_group.control-plane.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.node.id
}

resource "oci_core_network_security_group_security_rule" "control-plane-egress-nodes" {
  description               = "let control plane reach nodes"
  network_security_group_id = oci_core_network_security_group.control-plane.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination_type          = "NETWORK_SECURITY_GROUP"
  destination               = oci_core_network_security_group.node.id
}

resource "oci_core_network_security_group_security_rule" "control-plane-egress-pods" {
  description               = "let control plane reach pods for webhooks"
  network_security_group_id = oci_core_network_security_group.control-plane.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination_type          = "NETWORK_SECURITY_GROUP"
  destination               = oci_core_network_security_group.pod.id
}
