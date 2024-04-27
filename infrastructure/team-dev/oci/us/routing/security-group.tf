resource "oci_core_network_security_group" "world-to-lb" {
  compartment_id = var.compartment_id
  display_name   = "${local.name}-world-to-lb"
  vcn_id         = local.network.vcn_id
}

resource "oci_core_network_security_group_security_rule" "world-to-lb" {
  network_security_group_id = oci_core_network_security_group.world-to-lb.id
  direction                 = "INGRESS"
  protocol                  = 6
  source                    = "0.0.0.0/0"
}
