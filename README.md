# Terraform Automation for OVHcloud Public Cloud Instance (VPS)

This Terraform repository automates the deployment of a Virtual Private Server (VPS) 
hosted on the OVHcloud Public Cloud infrastructure using the native OVH Terraform provider. 

By default, this configuration deploys a **Fedora 43** instance configured 
with **VPS-1** flavor (4 vCores, 8 GB RAM, 75 GB NVMe storage), ensuring automatic system 
package updates on its first boot via cloud-init.

## Architecture & Features

- **Provider Integration:** Leverages the official `ovh/ovh` provider alongside `carlpett/sops` 
for secrets encryption management.
- **SSH Key Registration:** Dynamically injects and registers your public SSH key 
directly into your OVH Public Cloud project before provisioning the instance.
- **Pre-configured OS:** Deploys the latest matching standard image for **Fedora 43**.
- **Automated Provisioning:** Implements standard `cloud-init` configuration to perform safe 
`package_update` and `package_upgrade` processes upon system initialization.
- **Output Management:** Automatically displays the primary public IPv4 address assigned 
to the new VPS instance upon deployment completion.

---

## Prerequisites

Before executing the plan, make sure you have fulfilled the following requirements:

1. **Terraform CLI:** Install Terraform (`>= 1.5`).
2. **OVHcloud Public Cloud Project:** You must have an active Public Cloud Project. 
Note your **Project ID** from your OVHcloud Control Panel (visible under the *Public Cloud* section).
3. **Mozilla SOPS:** Installed locally to decrypt your local secrets file (`ovh.json`).
4. **OVHcloud API Credentials:** You need an Application Key, Application Secret, and Consumer Key.

---

## Secret Management Configuration

To keep infrastructure secure, sensitive API credentials and SSH public keys are managed using **SOPS** 
and fetched from a local `ovh.json` file. 

Create an encrypted `ovh.json` containing the following keys:

```json
{
  "ovh_application_key": "OVH_APP_KEY",
  "ovh_application_secret": "OVH_APP_SECRET",
  "ovh_consumer_key": "OVH_CONSUMER_KEY",
  "my_ssh_public_key": "ssh-rsa AAAAXXXXXXXX..."
}

```

---

## Variables Input Reference

The following inputs are declared in `var.tf` and can be customized to match your destination constraints:

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `ovh_project_id` | **Required.** The unique OVH Public Cloud Project ID alphanumeric string. | `string` | *None* |
| `region` | The OVH datacenter region where the instance will be provisioned. | `string` | `"GRA11"` (Gravelines) |
| `vps_flavor` | The sizing flavor profile (CPU/RAM/Disk profile) for the instance. | `string` | `"vps-1"` (4 vCores / 8GB / 75GB NVMe) |

---

## How To Use

### 1. Initialize Workspace

Run initialization to download the requested providers (`ovh` and `sops`) and configure the backend:

```bash
terraform init

```

### 2. Set Up the Project ID Variable

Provide your mandatory `ovh_project_id`. Export it inside your environment terminal shell:

```bash
export TF_VAR_ovh_project_id="ovh_project_id_hash"

```

Or define it in a local `terraform.tfvars` file (which is ignored by Git):

```hcl
ovh_project_id = "ovh_project_id_hash"

```

### 3. Generate Infrastructure Execution Plan

Review the changes that Terraform intends to apply onto cloud infrastructure:

```bash
terraform plan

```

### 4. Apply Changes

Provision automated SSH Key and Fedora Public Cloud instance:

```bash
terraform apply

```

### 5. Accessing the Instance

Once the creation is complete, Terraform will print the public IP output onto console terminal screen:

```bash
Outputs:
vps_public_ip = "192.168.2.1"

```

You can then log into instance using your matching SSH private key:

```bash
ssh fedora@<vps_public_ip>

```

