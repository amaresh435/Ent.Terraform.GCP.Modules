resource "google_container_node_pool" "primary" {
  project           = var.project_id
  name              = join("-", [local.resource_prefix, "primary", "nodepool"])
  location          = var.region
  cluster           = google_container_cluster.this.name
  node_count        = var.admin_node_count
  max_pods_per_node = var.max_pods_per_node
  version           = var.node_pool_k8s_version

  node_config {
    machine_type    = var.primary_node_machine_type
    labels          = merge(var.labels, { pool = "admin" })
    tags            = ["primary"]
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    service_account = var.cluster_svc_accnt_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/logging.admin",
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  upgrade_settings {
    strategy        = "SURGE"
    max_surge       = 1
    max_unavailable = 0
  }

  autoscaling {
    total_min_node_count = var.gke_autoscaling_config_primary_node.min_node_count
    total_max_node_count = var.gke_autoscaling_config_primary_node.max_node_count
    location_policy      = "BALANCED"
  }

  timeouts {
    create = "40m"
    update = "30m"
  }

  management {
    auto_rapair  = true
    auto_upgrade = false
  }

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count
    ]
  }
}
