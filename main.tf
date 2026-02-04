resource "random_id" "server" {
  byte_length = 8
}

locals {
  redis_count  = var.enable_redis ? 1 : 0
  valkey_count = var.enable_valkey ? 1 : 0
  redis_ip     = var.enable_redis ? google_redis_cluster.redis[0].discovery_endpoints[0].address : "127.0.0.1"
  valkey_ip    = var.enable_valkey ? google_memorystore_instance.valkey[0].endpoints[0].connections[0].psc_auto_connection[0].ip_address : "127.0.0.1"
}

resource "google_project_service" "servicenetworking" {
  project                    = var.gcp_project_id
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = var.disable_apis
  disable_on_destroy         = var.disable_apis
}

resource "google_project_service" "compute" {
  project                    = var.gcp_project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = var.disable_apis
  disable_on_destroy         = var.disable_apis
}

resource "google_project_service" "networkconnectivity" {
  project                    = var.gcp_project_id
  service                    = "networkconnectivity.googleapis.com"
  disable_dependent_services = var.disable_apis
  disable_on_destroy         = var.disable_apis
}
