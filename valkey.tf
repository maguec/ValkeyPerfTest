resource "google_memorystore_instance" "valkey" {
  project     = var.gcp_project_id
  instance_id = "valkey-${random_id.server.hex}"
  shard_count = 1
  desired_auto_created_endpoints {
    network    = google_compute_network.vpc.id
    project_id = var.gcp_project_id
  }
  location                = join("-", slice(split("-", var.gcp_zone), 0, 2))
  replica_count           = 0
  node_type               = "STANDARD_SMALL"
  transit_encryption_mode = "TRANSIT_ENCRYPTION_DISABLED"
  authorization_mode      = "AUTH_DISABLED"
  engine_configs = {
    maxmemory-policy = "volatile-ttl"
  }
  zone_distribution_config {
    mode = "SINGLE_ZONE"
    zone = var.gcp_zone
  }
  maintenance_policy {
    weekly_maintenance_window {
      day = "MONDAY"
      start_time {
        hours   = 1
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }
  engine_version              = "VALKEY_8_0"
  deletion_protection_enabled = false
  mode                        = "CLUSTER"
  persistence_config {
    mode = "RDB"
    rdb_config {
      rdb_snapshot_period     = "ONE_HOUR"
      rdb_snapshot_start_time = "2024-10-02T15:01:23Z"
    }
  }
  depends_on = [
    google_network_connectivity_service_connection_policy.psc
  ]

}
