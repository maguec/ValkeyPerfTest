resource "google_service_account" "lab_service_account" {
  project      = var.gcp_project_id
  account_id   = "account-${random_id.server.hex}"
  display_name = "Service Account ${random_id.server.hex}"
}
