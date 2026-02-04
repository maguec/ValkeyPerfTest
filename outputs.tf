output "vm_ssh_command" {
  value = "gcloud compute ssh --zone ${var.gcp_zone} vm-${random_id.server.hex} --project ${var.gcp_project_id}"
}

output "valkey" {
  value = local.valkey_ip
}

output "redis" {
  value = local.redis_ip
}
