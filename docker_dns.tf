# ---------------------------------------------------------------------------- #
# Docker Tunnel DNS Records and Configuration
# ---------------------------------------------------------------------------- #

# This file contains DNS records and configuration for the Docker tunnel
# Add Docker-specific DNS resources here when services are defined

# DNS records for Docker tunnel endpoints
resource "cloudflare_dns_record" "docker_tunnel_dns_records" {
  for_each = { for domain in local.docker_tunnel_dns : domain.name => domain }
  zone_id  = var.cf_docker_zone_id
  name     = each.value.name
  content  = "${module.docker_tunnel.tunnel_id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1
  comment  = "Managed by Terraform - Docker Tunnel"
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
