resource "google_compute_address" "static" {
  project    = var.gcp_project_id
  region     = join("-", slice(split("-", var.gcp_zone), 0, 2))
  name       = "ipv4-${random_id.server.hex}"
  depends_on = [google_project_service.compute, google_project_service.servicenetworking]
}

resource "google_compute_network" "vpc" {
  project    = var.gcp_project_id
  name       = "vpc-${random_id.server.hex}"
  depends_on = [google_project_service.compute, google_project_service.servicenetworking]
}

resource "google_compute_firewall" "full_access_for_user" {
  project = var.gcp_project_id

  name    = "firewall-${random_id.server.hex}"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8000"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["full-access-${random_id.server.hex}"]

}

#############################################################################
# PSC Setup
#############################################################################
resource "google_network_connectivity_service_connection_policy" "psc" {
  project       = var.gcp_project_id
  name          = "psc-${random_id.server.hex}"
  location      = join("-", slice(split("-", var.gcp_zone), 0, 2))
  service_class = "gcp-memorystore"
  description   = "PSC for Memorystore"
  network       = google_compute_network.vpc.id
  psc_config {
    subnetworks = [google_compute_subnetwork.psc_subnet.id]
  }
}

resource "google_compute_subnetwork" "psc_subnet" {
  project       = var.gcp_project_id
  name          = "subnet-${random_id.server.hex}"
  ip_cidr_range = "10.0.0.248/29"
  region        = join("-", slice(split("-", var.gcp_zone), 0, 2))
  network       = google_compute_network.vpc.id
}
