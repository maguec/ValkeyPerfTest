variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to apply this config to."
}

variable "gcp_zone" {
  type        = string
  description = "The GCP zone to apply this config to."
}

variable "disable_apis" {
  type        = bool
  description = "Do we disable apis when we are done"
  default     = false
}

# You can search using
# gcloud compute images list --sort-by creationTimestamp --project ubuntu-os-cloud  --no-standard-images

variable "instance_family" {
  type    = string
  default = "ubuntu-2404-lts-amd64"
}
variable "instance_project_id" {
  type    = string
  default = "ubuntu-os-cloud"
}

variable "machine_type" {
  type    = string
  default = "n2-standard-8"
}
