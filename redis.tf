resource "google_redis_cluster" "redis" {
  project                 = var.gcp_project_id
  name                    = "redis-cluster-${random_id.server.hex}"
  shard_count             = 3
  labels                  = {}
  region                  = join("-", slice(split("-", var.gcp_zone), 0, 2))
  replica_count           = 0
  node_type               = "REDIS_STANDARD_SMALL"
  transit_encryption_mode = "TRANSIT_ENCRYPTION_MODE_DISABLED"
  authorization_mode      = "AUTH_MODE_DISABLED"
  redis_configs = {
    maxmemory-policy = "volatile-ttl"
  }
  deletion_protection_enabled = false
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

  psc_configs {
    network = "projects/${var.gcp_project_id}/global/networks/vpc-${random_id.server.hex}"
  }

  depends_on = [
    time_sleep.wait_for_psc_policy,
    google_memorystore_instance.valkey
  ]
}

## PSC connection 


resource "google_redis_cluster_user_created_connections" "auto-conn" {
  name    = "auto-conn-${random_id.server.hex}"
  project = var.gcp_project_id
  region  = join("-", slice(split("-", var.gcp_zone), 0, 2))
  cluster_endpoints {
    connections {
      psc_connection {
        psc_connection_id  = google_compute_forwarding_rule.ipfwd.psc_connection_id
        address            = google_compute_address.psc_ip.address
        forwarding_rule    = google_compute_forwarding_rule.ipfwd.id
        network            = google_compute_network.vpc.id
        service_attachment = google_redis_cluster.redis.psc_service_attachments[0].service_attachment
      }
    }
  }
}

resource "google_compute_forwarding_rule" "ipfwd" {
  name                  = "fwd1-${random_id.server.hex}"
  project               = var.gcp_project_id
  region                = join("-", slice(split("-", var.gcp_zone), 0, 2))
  ip_address            = google_compute_address.psc_ip.id
  load_balancing_scheme = ""
  network               = google_compute_network.vpc.id
  target                = google_redis_cluster.redis.psc_service_attachments[0].service_attachment
}

resource "google_compute_address" "psc_ip" {
  project      = var.gcp_project_id
  name         = "fwd1-${random_id.server.hex}"
  region       = join("-", slice(split("-", var.gcp_zone), 0, 2))
  subnetwork   = google_compute_subnetwork.psc_subnet.id
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}
