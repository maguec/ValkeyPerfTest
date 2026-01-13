resource "random_id" "server" {
  byte_length = 8
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
