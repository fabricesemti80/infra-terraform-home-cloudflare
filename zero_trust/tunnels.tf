# Define the tunnel resource
#? Import it with "terraform import cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel ${TF_VAR_account_id}/ea8ef032-4e1b-408d-ba6d-abd101a6d54c"
#? $ terraform import cloudflare_zero_trust_tunnel_cloudflared.example <account_id>/<tunnel_id>
resource "cloudflare_zero_trust_tunnel_cloudflared" "existing_tunnel" {
  account_id = var.account_id
  name       = "docker-tunnel-new"
  secret     = var.tunnel_secret_docker # This should match your existing tunnel's secret
  # config_src = "cloudflare" # Use "local" if you want to manage config in Terraform
}

# Add DNS record for the tunnel
resource "cloudflare_record" "casa" {
  zone_id = var.zone_id
  name    = "casa"
  content   = "${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

# Add tunnel configuration with ingress rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id

  config {
    ingress_rule {
      hostname = "casa.fabricesemti.dev"
      service  = "http://localhost:8080"
    }
    
    # Default catch-all rule
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# # Existing Zero Trust tunnel resource
# resource "cloudflare_zero_trust_tunnel_cloudflared" "existing_tunnel" {
# account_id = var.account_id
# name = "docker-tunnel"
# secret = var.tunnel_secret_docker
# }

# Outputs for cloudfared configuration
output "tunnel_id" {
  description = "ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
}

output "tunnel_name" {
  description = "Name of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.name
}

output "credentials_json" {
  description = "JSON credentials content for ~/.cloudflared/<TUNNEL_ID>.json"
  sensitive   = true
  value       = jsonencode({
    AccountTag   = var.account_id
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
    TunnelName   = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.name
    TunnelSecret = var.tunnel_secret_docker
  })
}

output "config_yaml" {
  description = "YAML configuration for ~/.cloudflared/config.yaml"
  value       = yamlencode({
    tunnel            = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
    credentials-file  = "~/.cloudflared/${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id}.json"
    ingress = [
      {
        hostname = "casa.fabricesemti.dev" # Modify as needed
        service  = "http://localhost:8080" # Modify as needed
      },
      {
        service = "http_status:404" # Default catch-all rule
      }
    ]
  })
}

output "tunnel_token" {
  description = "Tunnel token for cloudflared"
  sensitive   = true
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.tunnel_token
}

# # Optional: Output for Docker configuration
# output "docker_config" {
# description = "Docker run command with environment variables"
# sensitive = true
# value = <<-EOT
# docker run -d \
# --name cloudflared \
# --restart unless-stopped \
# -e TUNNEL_TOKEN=${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id} \
# cloudflare/cloudflared:latest \
# tunnel run
# EOT
# }