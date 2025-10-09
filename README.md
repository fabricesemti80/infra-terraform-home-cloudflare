# Cloudflare Tunnel Infrastructure with Terraform

This repository provides a complete Terraform-based infrastructure solution for managing dual Cloudflare tunnels to expose Docker services securely over the internet. It automates the creation of tunnels, DNS records, and configuration files for various self-hosted services across two separate domains.

## 🚀 Overview

This project creates and manages:

- **Primary Tunnel** for Docker services (fs-tech.uk)
- **Secondary Tunnel** for Docker services (fabricesemti.dev)
- **DNS Records** for service discovery across both domains
- **Tunnel Configuration Files** for cloudflared clients
- **Ingress Rules** for routing traffic to specific services
- **Zero Trust Applications** with bypass policies for secure access

### Supported Services

The infrastructure supports exposing these services through dual Cloudflare tunnels:

**Primary Tunnel (fs-tech.uk):**

- **Homepage** (`homepage.fs-tech.uk`)
- **Sonarr** (`sonarr.fs-tech.uk`)
- **Overseerr** (`overseerr.fs-tech.uk`)
- **Radarr** (`radarr.fs-tech.uk`)

**Secondary Tunnel (fabricesemti.dev):**

- **Home Assistant** (`hass.fabricesemti.dev`)
- **Grafana** (`grafana.fabricesemti.dev`)
- **Jellyfin** (`jellyfin.fabricesemti.dev`)
- **Jellyseerr** (`jellyseerr.fabricesemti.dev`)
- **Kestra** (`kestra.fabricesemti.dev`)
- **N8N** (`n8n.fabricesemti.dev`)
- **Overseerr** (`overseerr.fabricesemti.dev`)
- **Plex** (`plex.fabricesemti.dev`)
- **Prometheus** (`prometheus.fabricesemti.dev`)
- **Prowlarr** (`prowlarr.fabricesemti.dev`)
- **Radarr** (`radarr.fabricesemti.dev`)
- **SABnzbd** (`sabnzbd.fabricesemti.dev`)
- **Sonarr** (`sonarr.fabricesemti.dev`)

## 📋 Prerequisites

Before using this repository, ensure you have:

### Required Accounts & Services

- **Cloudflare Account** with two registered domains (fs-tech.uk and fabricesemti.dev)
- **Terraform Cloud Account** (optional, for remote state management)

### Required Tools

- **Terraform** (v1.0+)
- **Git**
- **Cloudflare API Token** with appropriate permissions

### Required Permissions

Your Cloudflare API token needs these permissions:

- **Zone**: `Zone:Read`, `Zone:Edit`
- **Account**: `Account:Read`
- **Zero Trust**: `Zero Trust:Edit`

## ⚙️ Initial Setup

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd infra-terraform-home-cloudflare
```

### 2. Configure Variables

Create a `terraform.tfvars` file based on the example:

```bash
cp terraform_tfvars_example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values:

```hcl
# Cloudflare Account
cf_account_id = "your-cloudflare-account-id"
cf_api_token = "your-cloudflare-api-token"

# Primary Tunnel (fs-tech.uk)
cf_primary_domain = "fs-tech.uk"
cf_primary_zone_id = "your-primary-zone-id"

# Secondary Tunnel (fabricesemti.dev)
cf_secondary_domain = "fabricesemti.dev"
cf_secondary_zone_id = "your-secondary-zone-id"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

## 🔧 Configuration

### Service Customization

#### Adding New Services

To add a new service to the **Primary Tunnel** (fs-tech.uk), edit the `locals.tf` file:

```hcl
locals {
  primary_tunnel_ingress = [
    # Add your new service here
    {
      protocol = "http"
      name     = "your-service"
      host     = "your-service-host"  # Docker service name
      hostname = "your-service.${local.primary_tunnel_domain}"
      port     = 8080
    },
    # ... existing services
  ]
}
```

To add a new service to the **Secondary Tunnel** (fabricesemti.dev), edit the `locals.tf` file:

```hcl
locals {
  secondary_tunnel_ingress = [
    # Add your new service here
    {
      protocol = "http"
      name     = "your-service"
      host     = "10.0.40.20"  # Your service IP
      hostname = "your-service.${local.secondary_tunnel_domain}"
      port     = 8080          # Your service port
    },
    # ... existing services
  ]
}
```

#### Modifying Service Configuration

Each service configuration includes:

- `protocol`: Network protocol (usually "http")
- `name`: Service identifier
- `host`: Internal IP address of the service
- `hostname`: External domain name
- `port`: Internal port number

### Tunnel Configuration

#### Primary Tunnel (fs-tech.uk)

The primary tunnel exposes Docker services using service names. Default configuration:

- **Tunnel Name**: `tf-primary-tunnel`
- **Domain**: `fs-tech.uk`
- **Configuration Directory**: `config/`
- **Generated Files**:
  - `config/tf-primary-tunnel-token.json` - Tunnel credentials
  - `config/tf-primary-tunnel-config.yaml` - Tunnel configuration
  - `config/tf-primary-tunnel-cloudflared-token.txt` - Base64 encoded token

#### Secondary Tunnel (fabricesemti.dev)

The secondary tunnel exposes Docker services. Default configuration:

- **Tunnel Name**: `tf-secondary-tunnel`
- **Domain**: `fabricesemti.dev`
- **Configuration Directory**: `config/`
- **Generated Files**:
  - `config/tf-secondary-tunnel-token.json` - Tunnel credentials
  - `config/tf-secondary-tunnel-config.yaml` - Tunnel configuration
  - `config/tf-secondary-tunnel-cloudflared-token.txt` - Base64 encoded token
- **Zero Trust Applications**: Configured with bypass policies for secure access

## 🚀 Deployment

### Using Terraform CLI

```bash
# Initialize (first time only)
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure (if needed)
terraform destroy
```

### Using CI/CD Pipeline

The repository includes a Jenkins pipeline that:

1. Installs Terraform
2. Sets up SSH access
3. Runs `terraform init`, `terraform plan`, and `terraform apply`
4. Cleans up temporary files

### Manual Tunnel Client Setup

After running Terraform, you'll find generated configuration files in the `config/` directory. Use these with cloudflared:

```bash
# Install cloudflared (if not already installed)
# See: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/

# Run primary tunnel with generated config
cloudflared tunnel run --config config/tf-primary-tunnel-config.yaml

# Run secondary tunnel with generated config (on different host)
cloudflared tunnel run --config config/tf-secondary-tunnel-config.yaml
```

## 🔍 Verification

### Check Tunnel Status

```bash
# List tunnels in Cloudflare
cloudflared tunnel list

# View tunnel configuration
cloudflared tunnel info tf-primary-tunnel
cloudflared tunnel info tf-secondary-tunnel
```

### Test DNS Resolution

```bash
# Test primary tunnel domain resolution
nslookup homepage.fs-tech.uk

# Test secondary tunnel domain resolution
nslookup hass.fabricesemti.dev

# Test if the tunnels are working
curl -I https://homepage.fs-tech.uk
curl -I https://hass.fabricesemti.dev
```

### View Generated Files

After running Terraform, check the generated configuration files:

```bash
ls -la config/
cat config/tf-primary-tunnel-config.yaml
cat config/tf-secondary-tunnel-config.yaml
```

## 🛠️ Troubleshooting

### Common Issues

#### Tunnel Connection Failed

**Symptoms**: Services not accessible through the tunnel

**Solutions**:

1. Check if cloudflared is running: `cloudflared tunnel list`
2. Verify tunnel credentials: Check the generated token files
3. Check firewall settings on the host running cloudflared
4. Verify internal service is accessible on the specified host/port
5. Ensure correct tunnel is running for the domain (primary vs secondary)

#### DNS Not Resolving

**Symptoms**: Domain names not resolving to tunnel

**Solutions**:

1. Check if DNS records were created: Check Cloudflare dashboard for both zones
2. Verify the zone IDs and domain configuration for both tunnels
3. Wait for DNS propagation (can take up to 24 hours)
4. Ensure you're testing the correct domain (fs-tech.uk vs fabricesemti.dev)

#### Terraform Errors

**Symptoms**: Terraform apply fails

**Solutions**:

1. Check API token permissions for both zones
2. Verify all required variables are set (both primary and secondary)
3. Check Cloudflare account limits
4. Review Terraform logs for specific error messages
5. Ensure zone IDs match the correct domains

### Debug Mode

Enable debug logging for more detailed information:

```bash
# Terraform debug
TF_LOG=DEBUG terraform apply

# Cloudflared debug for primary tunnel
cloudflared tunnel run --config config/tf-primary-tunnel-config.yaml --loglevel debug

# Cloudflared debug for secondary tunnel
cloudflared tunnel run --config config/tf-secondary-tunnel-config.yaml --loglevel debug
```

## 🔄 Updates and Maintenance

### Updating Services

1. Edit the service configuration in `locals.tf` (primary_tunnel_ingress or secondary_tunnel_ingress)
2. Run `terraform plan` to see changes
3. Run `terraform apply` to update

### Adding New Tunnels

1. Create a new tunnel module configuration
2. Add variables for the new tunnel and domain
3. Update the main tunnel configuration files
4. Add DNS records for the new tunnel
5. Run `terraform apply`

### Repository Updates

```bash
# Pull latest changes
git pull origin main

# Review changes
git diff

# Update infrastructure
terraform plan
terraform apply
```

## 📁 Project Structure

```
├── config/                    # Generated tunnel configuration files
├── modules/
│   └── cloudflare-tunnel/     # Reusable tunnel module
│       ├── main.tf           # Tunnel resource definitions
│       ├── variables.tf      # Module input variables
│       └── outputs.tf        # Module outputs
├── *.tf                      # Main Terraform configuration files
├── terraform.tfvars          # Your environment variables
├── terraform_tfvars_example  # Example configuration
└── README.md                 # This file
```

## 🔒 Security Considerations

- **API Tokens**: Store tokens securely, never commit to version control
- **Tunnel Secrets**: Generated automatically, store the token files securely
- **Network Security**: Only expose necessary services through tunnels
- **Access Control**: Consider using Cloudflare Access for additional protection

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Terraform documentation
3. Check Cloudflare Zero Trust documentation
4. Open an issue in the repository

## 🔄 Long-term Maintenance

This documentation is designed to help you return to this project after months or years. Key points to remember:

1. **Configuration File**: Keep your `terraform.tfvars` file safe and backed up
2. **API Tokens**: Ensure your Cloudflare API token remains valid
3. **Dependencies**: Check for Terraform provider updates periodically
4. **Services**: Update service configurations as your infrastructure changes
5. **Security**: Regularly review and update security settings

### Quick Start After Long Absence
If returning after a long time:

1. **Verify Prerequisites**: Ensure all tools and accounts are still active
2. **Check Configuration**: Review your `terraform.tfvars` file
3. **Update Dependencies**: Run `terraform init -upgrade`
4. **Test Changes**: Run `terraform plan` to see what will change
5. **Apply Updates**: Run `terraform apply` to sync infrastructure
6. **Verify Services**: Test that all your services are accessible

---

**Last Updated**: September 2025
**Terraform Version**: 1.0+
**Cloudflare Provider Version**: 5.0.0

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 5.10.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.10.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_primary_tunnel"></a> [primary\_tunnel](#module\_primary\_tunnel) | ./modules/cloudflare-tunnel | n/a |
| <a name="module_secondary_tunnel"></a> [secondary\_tunnel](#module\_secondary\_tunnel) | ./modules/cloudflare-tunnel | n/a |

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.primary_dns_records](https://registry.terraform.io/providers/cloudflare/cloudflare/5.10.1/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.primary_tunnel_ingress_records](https://registry.terraform.io/providers/cloudflare/cloudflare/5.10.1/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.secondary_dns_records](https://registry.terraform.io/providers/cloudflare/cloudflare/5.10.1/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.secondary_tunnel_ingress_records](https://registry.terraform.io/providers/cloudflare/cloudflare/5.10.1/docs/resources/dns_record) | resource |
| [cloudflare_zero_trust_access_application.secondary_applications](https://registry.terraform.io/providers/cloudflare/cloudflare/5.10.1/docs/resources/zero_trust_access_application) | resource |
| [cloudflare_zero_trust_access_policy.secondary_zero_trust_access_policy](https://registry.terraform.io/providers/cloudflare/cloudflare/5.10.1/docs/resources/zero_trust_access_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cf_account_id"></a> [cf\_account\_id](#input\_cf\_account\_id) | The ID of the Cloudflare account. | `string` | n/a | yes |
| <a name="input_cf_api_token"></a> [cf\_api\_token](#input\_cf\_api\_token) | API token for authenticating with Cloudflare. | `string` | n/a | yes |
| <a name="input_cf_primary_domain"></a> [cf\_primary\_domain](#input\_cf\_primary\_domain) | The base domain for primary tunnel services (fs-tech.uk). | `string` | n/a | yes |
| <a name="input_cf_primary_zone_id"></a> [cf\_primary\_zone\_id](#input\_cf\_primary\_zone\_id) | The ID of the Cloudflare zone for the primary tunnel (fs-tech.uk). | `string` | n/a | yes |
| <a name="input_cf_secondary_domain"></a> [cf\_secondary\_domain](#input\_cf\_secondary\_domain) | The base domain for secondary tunnel services (fabricesemti.dev). | `string` | n/a | yes |
| <a name="input_cf_secondary_zone_id"></a> [cf\_secondary\_zone\_id](#input\_cf\_secondary\_zone\_id) | The ID of the Cloudflare zone for the secondary tunnel (fabricesemti.dev). | `string` | n/a | yes |
| <a name="input_config_dir"></a> [config\_dir](#input\_config\_dir) | Directory for configuration files. | `string` | `"config"` | no |
| <a name="input_terraformed_secondary_tunnel_config"></a> [terraformed\_secondary\_tunnel\_config](#input\_terraformed\_secondary\_tunnel\_config) | Configuration for the Terraformed secondary tunnel. | `string` | `""` | no |
| <a name="input_terraformed_secondary_tunnel_credential"></a> [terraformed\_secondary\_tunnel\_credential](#input\_terraformed\_secondary\_tunnel\_credential) | Credential for the Terraformed secondary tunnel. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_tunnel_ids"></a> [all\_tunnel\_ids](#output\_all\_tunnel\_ids) | Map of all tunnel IDs by tunnel type |
| <a name="output_primary_tunnel_config_content"></a> [primary\_tunnel\_config\_content](#output\_primary\_tunnel\_config\_content) | YAML content for the primary tunnel configuration file |
| <a name="output_primary_tunnel_id"></a> [primary\_tunnel\_id](#output\_primary\_tunnel\_id) | ID of the primary Cloudflare Tunnel |
| <a name="output_primary_tunnel_name"></a> [primary\_tunnel\_name](#output\_primary\_tunnel\_name) | Name of the primary Cloudflare Tunnel |
| <a name="output_secondary_tunnel_config_content"></a> [secondary\_tunnel\_config\_content](#output\_secondary\_tunnel\_config\_content) | YAML content for the secondary tunnel configuration file |
| <a name="output_secondary_tunnel_id"></a> [secondary\_tunnel\_id](#output\_secondary\_tunnel\_id) | ID of the secondary Cloudflare Tunnel |
| <a name="output_secondary_tunnel_name"></a> [secondary\_tunnel\_name](#output\_secondary\_tunnel\_name) | Name of the secondary Cloudflare Tunnel |
<!-- END_TF_DOCS -->