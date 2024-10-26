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
      name     = "nextcloud"
      hostname = "nextcloud.fabricesemti.dev"
      port     = 10081
    },
    {
      name     = "plex"
      hostname = "plex.fabricesemti.dev"
      port     = 32400
    },
    {
      name     = "portainer"
      hostname = "portainer.fabricesemti.dev"
      port     = 9000
    },
    {
      name     = "prowlarr"
      hostname = "prowlarr.fabricesemti.dev"
      port     = 9696
    },
    {
      name     = "sonarr"
      hostname = "sonarr.fabricesemti.dev"
      port     = 8989
    },
    {
      name     = "transmission"
      hostname = "transmission.fabricesemti.dev"
      port     = 9091
    },
  ]
}
# Add DNS records for each domain specified in locals
resource "cloudflare_record" "dns_records" {
  for_each = { for domain in local.domains : domain.name => domain }
  zone_id  = var.cf_zone_id
  name     = each.value.name
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
}
# Configure tunnel ingress rules dynamically based on locals
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  account_id = var.cf_account_id
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
