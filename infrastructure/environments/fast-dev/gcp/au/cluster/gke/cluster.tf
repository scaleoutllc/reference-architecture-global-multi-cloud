
resource "google_container_cluster" "main" {
  name                     = local.name
  min_master_version       = "1.28.8-gke.1095000"
  enable_l4_ilb_subsetting = true
  networking_mode          = "VPC_NATIVE"
  network                  = local.network.id
  subnetwork               = local.network.subnet_id
  ip_allocation_policy {
    // Refers to secondary_ip_range entries in subnetwork.
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "192.168.3.0/28"
  }
  # List of networks that can contact the control plane.
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "all-for-testing"
    }
  }
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}
