resource "google_service_account" "nodes" {
  project      = var.project_id
  account_id   = "${substr(var.cluster_name, 0, 20)}-nodes"
  display_name = "GKE node service account for ${var.cluster_name}"
}

resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.env_location

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1
  min_master_version       = var.min_master_k8s_version

  datapath_provider   = "ADVANCED_DATAPATH"
  deletion_protection = false

  default_snat_status {
    disabled = true
  }

  ip_allocation_policy {
    cluster_secondary_range_name = var.pod_subnet_name
    service_scondary_range_name  = var.svc_subnet_name
  }

  workload_identity_config {
    workload_pool = "${var.k8s_project}.svc.id.goog"
  }

  node_config {
    service_account = google_service_account.cluster.email
    tags            = [join("-"), [local.resource_prefix, "node", "pool"]]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/logging.admin",
    ]
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  private_cluster_congif {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cide_block  = var.cluster_master_cidr
  }

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "WORKLOADS",
    ]
  }

  monitering_config {
    managed_prometheus {
      enabled = true
    }
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "WORKLOADS",
    ]
  }

  resource_labels = var.labels

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count
    ]
  }
}
