data "google_compute_image" "image" {
  family     = var.instance_family
  project    = var.instance_project_id
  depends_on = [google_project_service.compute, google_project_service.servicenetworking]
}
