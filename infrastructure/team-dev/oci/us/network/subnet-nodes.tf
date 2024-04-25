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
  ]
}

resource "oci_core_network_security_group" "node" {
  compartment_id = local.compartment_id
  display_name   = "${local.envName}-node"
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_network_security_group_security_rule" "node-egress-world" {
  description               = "let nodes egress anywhere"
  network_security_group_id = oci_core_network_security_group.node.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "node-ingress-pod" {
  description               = "let pods reach other nodes"
  network_security_group_id = oci_core_network_security_group.node.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.pod.id
}

resource "oci_core_network_security_group_security_rule" "node-ingress-node" {
  description               = "let nodes reach other nodes"
  network_security_group_id = oci_core_network_security_group.node.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.node.id
}

resource "oci_core_network_security_group_security_rule" "control-plane-ingress-node" {
  description               = "let control plane reach nodes"
  network_security_group_id = oci_core_network_security_group.node.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.control-plane.id
}
