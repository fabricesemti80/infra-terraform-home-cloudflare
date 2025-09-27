# ---------------------------------------------------------------------------- #
# Docker Tunnel DNS Records and Configuration
# ---------------------------------------------------------------------------- #

# This file contains DNS records and configuration for the Docker tunnel
# Add Docker-specific DNS resources here when services are defined

# DNS records for Docker tunnel endpoints
# Uncomment and modify when docker_tunnel_dns locals are defined
resource "cloudflare_dns_record" "docker_tunnel_dns_records" {
  for_each = { for domain in local.docker_tunnel_dns : domain.name => domain }
  zone_id  = var.cf_docker_zone_id
  name     = each.value.name
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1
  comment  = "Managed by Terraform - Docker Tunnel"
}

# Docker tunnel configuration defining ingress rules
# Uncomment and modify when docker_tunnel_dns locals are defined
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "docker_tunnel_config" {
  account_id = var.cf_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id

  config = {
    ingress = concat(
      [
        for domain in local.docker_tunnel_dns : {
          hostname = domain.hostname
          service  = "${domain.protocol}://${domain.host}:${domain.port}"
        }
      ],
      [
        {
          service = "http_status:404"
        }
      ]
    )
  }
}

# Additional DNS records for Docker services
# Uncomment and modify when docker_other_dns locals are defined
resource "cloudflare_dns_record" "docker_dns_records" {
  for_each = { for domain in local.docker_other_dns : domain.name => domain }
  zone_id  = var.cf_docker_zone_id
  name     = each.value.name
  content  = each.value.content
  type     = each.value.type
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  comment  = "Managed by Terraform - Docker Services"
}
