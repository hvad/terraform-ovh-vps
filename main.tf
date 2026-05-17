# Create and register the public SSH key into the specified OVH Public Cloud project
resource "ovh_cloud_project_ssh_key" "vps_key" {
  service_name = var.public_cloud_project_id
  name         = "terraform-automation-key"
  public_key   = data.sops_file.secrets.data["my_ssh_public_key"]
}

# Deploy the Public Cloud Instance (VPS) entirely using the native OVH provider
resource "ovh_cloud_project_instance" "vps_fedora" {
  service_name = var.ovh_project_id
  name         = "fedora-doc"
  region       = var.region
  flavor_name  = var.vps_flavor

  # The native OVH provider maps this string directly to the latest matching standard OS image
  image_name = "Fedora 43"

  # Link the instance to the managed SSH key resource defined above
  ssh_key_id = ovh_cloud_project_ssh_key.vps_key.id

  # Optional: Standard cloud-init configuration to ensure the system updates on first boot
  user_data = <<-EOF
              #cloud-config
              package_update: true
              package_upgrade: true
              EOF
}
