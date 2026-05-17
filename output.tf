# Extract and display the main public IPv4 address assigned to the new instance
output "vps_public_ip" {
  value       = ovh_cloud_project_instance.vps_fedora.ip_addresses[0].ip
  description = "The primary public IPv4 address of the deployed Fedora."
}
