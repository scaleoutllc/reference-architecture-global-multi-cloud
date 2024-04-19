// assigned to routing nodes / load balancers for internal comms
resource "oci_core_network_security_group" "internal-ingress" {
  compartment_id = local.compartment_id
  display_name   = "${local.envName}-internal-ingress"
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_network_security_group_security_rule" "internal-ingress" {
  network_security_group_id = oci_core_network_security_group.internal-ingress.id
  direction                 = "INGRESS"
  protocol                  = 6
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.internal-ingress.id
}

// assigned to all pods
resource "oci_core_network_security_group" "pod" {
  compartment_id = local.compartment_id
  display_name   = "${local.envName}-pod"
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_network_security_group_security_rule" "pod-egress-world" {
  description               = "let pods egress anywhere"
  network_security_group_id = oci_core_network_security_group.pod.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "pod-ingress-pod" {
  description               = "let pods reach other pods"
  network_security_group_id = oci_core_network_security_group.pod.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source_type               = "NETWORK_SECURITY_GROUP"
  source                    = oci_core_network_security_group.pod.id
}
