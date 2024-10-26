# Define the tunnel resource
#? Import it with "terraform import cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel ${TF_VAR_account_id}/ea8ef032-4e1b-408d-ba6d-abd101a6d54c"
#? $ terraform import cloudflare_zero_trust_tunnel_cloudflared.example <account_id>/<tunnel_id>
# Define locals for hostname, domain, and port
locals {
  domains = [
    {
      name     = "casa"
      hostname = "casa.fabricesemti.dev"
      port     = 8080
    },
    {
      name     = "jelly"
      hostname = "jelly.fabricesemti.dev"
      port     = 8097
    },
    {
      name     = "plex"
      hostname = "plex.fabricesemti.dev"
      port     = 32400
    }    
  ]
}

# Define the tunnel resource and import it
resource "cloudflare_zero_trust_tunnel_cloudflared" "existing_tunnel" {
  account_id = var.account_id
  name       = "docker-tunnel-new"
  secret     = var.tunnel_secret_docker
}

# Add DNS records for each domain specified in locals
resource "cloudflare_record" "dns_records" {
  for_each = { for domain in local.domains : domain.name => domain }
  
  zone_id = var.zone_id
  name    = each.value.name
  content = "${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

# Configure tunnel ingress rules dynamically based on locals
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id

  config {
    # Dynamic ingress rules from locals
    dynamic "ingress_rule" {
      for_each = local.domains
      content {
        hostname = ingress_rule.value.hostname
        service  = "http://localhost:${ingress_rule.value.port}"
      }
    }

    # Default catch-all rule
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Outputs for Cloudflare configuration
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

# output "config_yaml" {
#   description = "YAML configuration for ~/.cloudflared/config.yaml"
#   value       = yamlencode({
#     tunnel            = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
#     credentials-file  = "~/.cloudflared/${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id}.json"
#     ingress = [
#       for domain in local.domains : {
#         hostname = domain.hostname
#         service  = "http://localhost:${domain.port}"
#       },
#       {
#         service = "http_status:404" # Default catch-all rule
#       }
#     ]
#   })s
# }

output "tunnel_token" {
  description = "Tunnel token for cloudflared"
  sensitive   = true
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.tunnel_token
}
