resource "google_compute_firewall" "gke_ingress" {
  count = length(var.firewall_source_ranges) > 0 ? 1 : 0

  project       = var.project_id
  name          = "${var.cluster_name}-gke-ingress"
  network       = var.network
  direction     = "INGRESS"
  source_ranges = var.firewall_source_ranges
  target_tags   = ["${var.cluster_name}-gke-node"]

  allow {
    protocol = "tcp"
    ports    = var.firewall_allowed_ports
  }
}
