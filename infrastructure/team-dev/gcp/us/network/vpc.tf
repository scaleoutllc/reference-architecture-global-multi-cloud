resource "google_compute_network" "main" {
  name                    = local.name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "main" {
  name                     = local.region
  ip_cidr_range            = local.network.cidr
  network                  = google_compute_network.main.self_link
  private_ip_google_access = true
  purpose                  = "PRIVATE"
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = local.network.ranges.pods
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = local.network.ranges.services
  }
  secondary_ip_range {
    range_name    = "private"
    ip_cidr_range = local.network.ranges.private
  }
}

// Create a static public IP for each region to be used for ingress.
resource "google_compute_address" "public" {
  name = local.name
}

// Create router to give outbound internet connectivity to network.
resource "google_compute_router" "main" {
  name    = local.name
  network = google_compute_network.main.self_link
}

// Allow outbound internet access on all subnetworks except "private".
resource "google_compute_router_nat" "main" {
  name                               = local.name
  router                             = google_compute_router.main.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.main.id
    source_ip_ranges_to_nat = [
      "PRIMARY_IP_RANGE",
      "LIST_OF_SECONDARY_IP_RANGES"
    ]
    secondary_ip_range_names = [
      "pods",
      "services"
    ]
  }
}

resource "google_compute_firewall" "ingress" {
  name      = "${local.name}-gcp-lb-ingress"
  network   = google_compute_network.main.id
  direction = "INGRESS"
  priority  = 1000
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = [
    // https://cloud.google.com/load-balancing/docs/firewall-rules
    // allow google load balancers to health check internally
    "35.191.0.0/16"
  ]
}
