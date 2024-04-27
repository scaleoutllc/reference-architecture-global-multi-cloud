# // TODO: load balancers target a single subnet, are they automatically deployed
# // across all availability domains in the subnet?
# resource "oci_network_load_balancer_network_load_balancer" "public-ingress" {
#   compartment_id                 = var.compartment_id
#   display_name                   = local.name
#   subnet_id                      = local.network.public_subnet.id
#   is_private                     = false
#   is_preserve_source_destination = false
#   network_security_group_ids = [
#     oci_core_network_security_group.world-to-lb.id,
#     local.network.internal_ingress_security_group_id
#   ]
# }


# resource "oci_network_load_balancer_backend_set" "public-ingress" {
#   name                     = "${local.name}-ingress"
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public-ingress.id
#   policy                   = "FIVE_TUPLE"
#   health_checker {
#     protocol           = "HTTP"
#     interval_in_millis = 60000
#     port               = 30021
#     retries            = 2
#     return_code        = "200"
#     timeout_in_millis  = 3000
#     url_path           = "/healthz/ready"
#   }
# }

# resource "oci_network_load_balancer_backend" "public-ingress" {
#   count                    = length(local.active_nodes)
#   backend_set_name         = oci_network_load_balancer_backend_set.public-ingress.name
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public-ingress.id
#   port                     = 30080
#   target_id                = local.active_nodes[count.index].id
# }

# resource "oci_network_load_balancer_listener" "public-ingress" {
#   default_backend_set_name = oci_network_load_balancer_backend_set.public-ingress.name
#   name                     = "${local.name}-ingress"
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.public-ingress.id
#   port                     = 80
#   protocol                 = "TCP"
# }
