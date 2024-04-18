resource "oci_core_network_security_group" "world-to-lb" {
  compartment_id = local.compartment_id
  display_name   = "${local.name}-world-to-lb"
  vcn_id         = local.network.vcn_id
}

resource "oci_core_network_security_group_security_rule" "world-to-lb" {
  network_security_group_id = oci_core_network_security_group.world-to-lb.id
  direction                 = "INGRESS"
  protocol                  = 6
  source                    = "0.0.0.0/0"
}

// TODO: load balancers target a single subnet, are they automatically deployed
// across all availability domains in the subnet?
resource "oci_network_load_balancer_network_load_balancer" "public-ingress" {
  compartment_id                 = local.compartment_id
  display_name                   = local.name
  subnet_id                      = local.network.public_subnet.id
  is_private                     = false
  is_preserve_source_destination = false
  network_security_group_ids = [
    oci_core_network_security_group.world-to-lb.id,
    local.cluster.lb-to-cluster
  ]
}

resource "oci_network_load_balancer_backend_set" "public-ingress" {
  name                     = "${local.name}-ingress"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public-ingress.id
  policy                   = "FIVE_TUPLE"
  health_checker {
    protocol           = "HTTP"
    interval_in_millis = 60000
    port               = 30877
    retries            = 2
    return_code        = "200"
    timeout_in_millis  = 3000
    url_path           = "/"
  }
}

// TODO: either use k8s load balancer services for ingress, address the
// lack of ability to target a node pool with a network load balancer or
// accept that rotating routing nodes will require some kind of integration
// with this workspace.
data "oci_containerengine_node_pool" "routing" {
  node_pool_id = local.cluster.routing-node-pool-id
}
locals {
  active_nodes = [
    for node in data.oci_containerengine_node_pool.routing.nodes : node if node.state == "ACTIVE"
  ]
}

resource "oci_network_load_balancer_backend" "public-ingress" {
  count                    = length(local.active_nodes)
  backend_set_name         = oci_network_load_balancer_backend_set.public-ingress.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public-ingress.id
  port                     = 30877
  target_id                = local.active_nodes[count.index].id
}

resource "oci_network_load_balancer_listener" "public-ingress" {
  default_backend_set_name = oci_network_load_balancer_backend_set.public-ingress.name
  name                     = "${local.name}-ingress"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public-ingress.id
  port                     = "80"
  protocol                 = "TCP"
}
