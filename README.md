# Cloudflare Tunnel Infrastructure with Terraform

This repository provides a complete Terraform-based infrastructure solution for managing Cloudflare tunnels to expose Docker and Kubernetes services securely over the internet. It automates the creation of tunnels, DNS records, and configuration files for various self-hosted services.

## 🚀 Overview

This project creates and manages:
- **Cloudflare Tunnels** for secure access to internal services
- **DNS Records** for service discovery
- **Tunnel Configuration Files** for cloudflared clients
- **Ingress Rules** for routing traffic to specific services

### Supported Services

The infrastructure supports exposing these services through Cloudflare tunnels:
- **Home Assistant** (`hass.yourdomain.com`)
- **Grafana** (`grafana.yourdomain.com`)
- **Jellyfin** (`jellyfin.yourdomain.com`)
- **Jellyseerr** (`jellyseerr.yourdomain.com`)
- **Kestra** (`kestra.yourdomain.com`)
- **N8N** (`n8n.yourdomain.com`)
- **Overseerr** (`overseerr.yourdomain.com`)
- **Plex** (`plex.yourdomain.com`)
- **Prometheus** (`prometheus.yourdomain.com`)
- **Prowlarr** (`prowlarr.yourdomain.com`)
- **Radarr** (`radarr.yourdomain.com`)
- **SABnzbd** (`sabnzbd.yourdomain.com`)
- **Sonarr** (`sonarr.yourdomain.com`)

## 📋 Prerequisites

Before using this repository, ensure you have:

### Required Accounts & Services
- **Cloudflare Account** with a registered domain
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
cf_account_id = "your-cloudflare-account-id"
cf_docker_zone_id = "your-cloudflare-zone-id"
cf_docker_domain = "yourdomain.com"
cf_api_token = "your-cloudflare-api-token"
tunnel_secret = "your-tunnel-secret"
tunnel_name = "your-tunnel-name"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 5. Review the Plan
```bash
terraform plan
```

### 6. Apply the Configuration
```bash
terraform apply
```

## 🔧 Configuration

### Service Customization

#### Adding New Services
To add a new service, edit the `docker_locals.tf` file:

```hcl
locals {
  docker_tunnel_dns = [
    # Add your new service here
    {
      protocol = "http"
      name     = "your-service"
      host     = "192.168.1.100"  # Your service IP
      hostname = "your-service.${local.docker_domain}"
      port     = 8080             # Your service port
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

#### Docker Tunnel
The Docker tunnel exposes services running on Docker hosts. Default configuration:
- **Tunnel Name**: `tf-docker-tunnel`
- **Configuration Directory**: `config/`
- **Generated Files**:
  - `config/tf-docker-tunnel-token.json` - Tunnel credentials
  - `config/tf-docker-tunnel-config.yaml` - Tunnel configuration
  - `config/tf-docker-tunnel-cloudflared-token.txt` - Base64 encoded token

#### Kubernetes Tunnel
The Kubernetes tunnel exposes services running on Kubernetes clusters. Default configuration:
- **Tunnel Name**: `tf-kubernetes-tunnel`
- **Configuration Directory**: `config/`
- **Generated Files**:
  - `config/tf-kubernetes-tunnel-token.json` - Tunnel credentials
  - `config/tf-kubernetes-tunnel-config.yaml` - Tunnel configuration
  - `config/tf-kubernetes-tunnel-cloudflared-token.txt` - Base64 encoded token

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

# Run tunnel with generated config
cloudflared tunnel run --config config/tf-docker-tunnel-config.yaml
```

## 🔍 Verification

### Check Tunnel Status
```bash
# List tunnels in Cloudflare
cloudflared tunnel list

# View tunnel configuration
cloudflared tunnel info <tunnel-name>
```

### Test DNS Resolution
```bash
# Test if your domain resolves correctly
nslookup hass.yourdomain.com

# Test if the tunnel is working
curl -I https://hass.yourdomain.com
```

### View Generated Files
After running Terraform, check the generated configuration files:
```bash
ls -la config/
cat config/tf-docker-tunnel-config.yaml
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

#### DNS Not Resolving
**Symptoms**: Domain names not resolving to tunnel
**Solutions**:
1. Check if DNS records were created: Check Cloudflare dashboard
2. Verify the zone ID and domain configuration
3. Wait for DNS propagation (can take up to 24 hours)

#### Terraform Errors
**Symptoms**: Terraform apply fails
**Solutions**:
1. Check API token permissions
2. Verify all required variables are set
3. Check Cloudflare account limits
4. Review Terraform logs for specific error messages

### Debug Mode
Enable debug logging for more detailed information:
```bash
# Terraform debug
TF_LOG=DEBUG terraform apply

# Cloudflared debug
cloudflared tunnel run --config config/tf-docker-tunnel-config.yaml --loglevel debug
```

## 🔄 Updates and Maintenance

### Updating Services
1. Edit the service configuration in `docker_locals.tf`
2. Run `terraform plan` to see changes
3. Run `terraform apply` to update

### Adding New Tunnels
1. Create a new tunnel module configuration
2. Add variables for the new tunnel
3. Update the main tunnel configuration files
4. Run `terraform apply`

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
