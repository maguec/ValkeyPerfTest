resource "google_redis_cluster" "redis" {
  project                     = var.gcp_project_id
  name                        = "redis-cluster-${random_id.server.hex}"
  shard_count                 = 3
  region                      = join("-", slice(split("-", var.gcp_zone), 0, 2))
  replica_count               = 0
  node_type                   = "REDIS_STANDARD_SMALL"
  transit_encryption_mode     = "TRANSIT_ENCRYPTION_MODE_DISABLED"
  authorization_mode          = "AUTH_MODE_DISABLED"
  deletion_protection_enabled = false

  psc_configs {
    network = google_compute_network.vpc.id
  }

  zone_distribution_config {
    mode = "SINGLE_ZONE"
    zone = var.gcp_zone
  }

  depends_on = [
    google_network_connectivity_service_connection_policy.psc-redis
  ]
}
