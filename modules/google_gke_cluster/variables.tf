variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  description = "Region in which to create the regional GKE cluster."
}

variable "cluster_name" {
  type = string
}

variable "network" {
  type        = string
  description = "VPC network name or self link. Use a self link for Shared VPC."
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork name or self link."
}

variable "pod_subnet_name" {
  type        = string
  description = "Name of the subnetwork secondary IP range used by Pods."
}

variable "svc_subnet_name" {
  type        = string
  description = "Name of the subnetwork secondary IP range used by Services."
}

variable "cluster_master_cidr" {
  type        = string
  description = "Non-overlapping /28 CIDR for the private GKE control plane."
}

variable "workload_identity_project_id" {
  type        = string
  default     = null
  description = "Project ID used in the Workload Identity pool. Defaults to project_id."
}

variable "enable_required_apis" {
  type        = bool
  default     = false
  description = "Enable the GKE prerequisite APIs in project_id. Service Usage must already be enabled."
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Optional minimum GKE control-plane version. Null uses the release-channel default."
}

variable "node_version" {
  type        = string
  default     = null
  description = "Optional node-pool version. Null lets GKE choose a compatible version."
}

variable "release_channel" {
  type    = string
  default = "REGULAR"

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE", "UNSPECIFIED"], var.release_channel)
    error_message = "release_channel must be RAPID, REGULAR, STABLE, or UNSPECIFIED."
  }
}

variable "primary_node_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "primary_node_count" {
  type    = number
  default = 1
}

variable "admin_node_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "admin_node_count" {
  type    = number
  default = 1
}

variable "gke_autoscaling_config_primary_node" {
  type = object({ min_node_count = number, max_node_count = number })
  default = {
    min_node_count = 1
    max_node_count = 3
  }
}

variable "gke_autoscaling_config_admin_node" {
  type = object({ min_node_count = number, max_node_count = number })
  default = {
    min_node_count = 1
    max_node_count = 3
  }
}

variable "max_pods_per_node" {
  type    = number
  default = 110
}

variable "disk_size_gb" {
  type    = number
  default = 100
}

variable "disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "node_auto_upgrade" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "disable_default_snat" {
  type        = bool
  default     = false
  description = "Set true only when Cloud NAT or another egress path is configured."
}

variable "enable_private_endpoint" {
  type        = bool
  default     = false
  description = "When true, control-plane access is only available from the VPC."
}

variable "master_authorized_networks" {
  description = "CIDR blocks permitted to use the public Kubernetes control-plane endpoint."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "firewall_source_ranges" {
  type        = list(string)
  default     = []
  description = "CIDR ranges permitted to connect to workload ports exposed by the GKE nodes."
}

variable "firewall_allowed_ports" {
  type    = list(string)
  default = ["80", "443"]
}

variable "grant_node_artifact_registry_reader" {
  type        = bool
  default     = false
  description = "Grant project-wide Artifact Registry read access to nodes. Prefer repository-level IAM where possible."
}

variable "cluster_admin_members" {
  type        = list(string)
  default     = []
  description = "IAM members (for example, group:platform@example.com) granted GKE administrator access."
}

variable "cluster_developer_members" {
  type        = list(string)
  default     = []
  description = "IAM members granted GKE developer access to Kubernetes API objects."
}
