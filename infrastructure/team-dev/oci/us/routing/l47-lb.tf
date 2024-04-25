resource "oci_load_balancer_load_balancer" "public-ingress" {
  compartment_id = local.compartment_id
  display_name   = local.name
  subnet_ids     = [local.network.public_subnet.id]
  is_private     = false
  network_security_group_ids = [
    oci_core_network_security_group.world-to-lb.id,
    local.network.internal_ingress_security_group_id
  ]
  shape = "100Mbps"
  # free tier doesn't allow this
  #shape = "flexible"
  #shape_details {
  #  maximum_bandwidth_in_mbps = 1500
  #  minimum_bandwidth_in_mbps = 1500
  #}
}

resource "oci_load_balancer_hostname" "public-ingress" {
  hostname         = local.routing.domain
  load_balancer_id = oci_load_balancer_load_balancer.public-ingress.id
  name             = local.name
}

resource "oci_load_balancer_certificate" "public-ingress" {
  certificate_name   = local.routing.domain
  load_balancer_id   = oci_load_balancer_load_balancer.public-ingress.id
  ca_certificate     = local.routing.cert.issuer_pem
  private_key        = local.routing.cert.private_key_pem
  public_certificate = local.routing.cert.certificate_pem
}

resource "oci_load_balancer_backend_set" "public-ingress" {
  name             = "${local.name}-ingress"
  load_balancer_id = oci_load_balancer_load_balancer.public-ingress.id
  policy           = "LEAST_CONNECTIONS"
  health_checker {
    protocol          = "HTTP"
    interval_ms       = 60000
    port              = 30021
    retries           = 2
    return_code       = "200"
    timeout_in_millis = 3000
    url_path          = "/healthz/ready"
  }
}

resource "oci_load_balancer_backend" "public-ingress" {
  count            = length(local.active_nodes)
  backendset_name  = oci_load_balancer_backend_set.public-ingress.name
  load_balancer_id = oci_load_balancer_load_balancer.public-ingress.id
  port             = 30080
  ip_address       = local.active_nodes[count.index].private_ip
}

resource "oci_load_balancer_listener" "public-ingress" {
  default_backend_set_name = oci_load_balancer_backend_set.public-ingress.name
  name                     = "${local.name}-ingress"
  load_balancer_id         = oci_load_balancer_load_balancer.public-ingress.id
  port                     = 443
  protocol                 = "HTTP"
  hostname_names           = [oci_load_balancer_hostname.public-ingress.name]
  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.public-ingress.certificate_name
    verify_peer_certificate = false
  }
}
