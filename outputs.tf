output "vm_ssh_command" {
  value = "gcloud compute ssh --zone ${var.gcp_zone} vm-${random_id.server.hex} --project ${var.gcp_project_id}"
}

output "valkey" {
  value = google_memorystore_instance.valkey.endpoints[0].connections[0].psc_auto_connection[0].ip_address
}
