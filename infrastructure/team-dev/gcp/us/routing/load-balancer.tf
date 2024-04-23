data "google_compute_zones" "this_env" {}
data "google_compute_network_endpoint_group" "ingress" {
  for_each = toset(data.google_compute_zones.this_env.names)
  name     = "${local.envName}-http"
  zone     = each.value
}

// this health check is only here to satisfy the requirement that one must
// exist. in this routing configuration, "backends" are network endpoints
// that route directly to pods in the cluster. the existence of the backend
// to health check at all (at this level) is predicated on a pod passing
// liveness and readiness checking in the cluster itself.
resource "google_compute_health_check" "ingress" {
  name                = "${local.name}-ingress"
  timeout_sec         = 1
  check_interval_sec  = 2
  healthy_threshold   = 1
  unhealthy_threshold = 3
  tcp_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_backend_service" "ingress" {
  name                  = "${local.name}-ingress"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks = [
    google_compute_health_check.ingress.id
  ]
  dynamic "backend" {
    for_each = data.google_compute_network_endpoint_group.ingress
    iterator = neg
    content {
      balancing_mode = "RATE"
      max_rate       = 1
      group          = neg.value.self_link
    }
  }
}

resource "google_compute_url_map" "ingress" {
  name            = "${local.name}-ingress"
  default_service = google_compute_backend_service.ingress.id
  path_matcher {
    name            = "all"
    default_service = google_compute_backend_service.ingress.id
  }
}

resource "google_compute_target_https_proxy" "ingress" {
  name            = "${local.name}-tls-terminate"
  url_map         = google_compute_url_map.ingress.id
  certificate_map = "//certificatemanager.googleapis.com/${local.routing.certificate_map_id}"
}

resource "google_compute_global_forwarding_rule" "ingress" {
  name                  = "${local.name}-public"
  target                = google_compute_target_https_proxy.ingress.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
