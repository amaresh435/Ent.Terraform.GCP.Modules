variable "project_id" { type = string }
variable "region" { type = string }
variable "cluster_name" { type = string }
variable "network" { type = string }
variable "subnetwork" { type = string }

variable "labels" {
  type    = map(string)
  default = {}
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Optional GKE version; null uses the GKE release channel default."
}

variable "release_channel" {
  type    = string
  default = "REGULAR"
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

variable "master_authorized_networks" {
  description = "CIDR blocks permitted to access the Kubernetes control plane."
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
