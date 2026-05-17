variable "ovh_project_id" {
  type        = string
  description = "The OVH Public Cloud Project ID"
}

variable "region" {
  type        = string
  default     = "GRA11"
  description = "The OVH datacenter region where the VPS will be provisioned"
}

variable "vps_flavor" {
  type        = string
  default     = "d2-2"
  description = "The resource model/flavor size for the instance (CPU/RAM/Disk profile)"
}
