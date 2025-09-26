# ---------------------------------------------------------------------------- #
# Main Tunnel DNS Records and Configuration
# ---------------------------------------------------------------------------- #

# DNS records for main tunnel endpoints
# These CNAME records point to the Cloudflare tunnel for routing traffic
resource "cloudflare_dns_record" "tunnel_dns_records" {
  for_each = { for domain in local.tunnel_dns : domain.name => domain }
  zone_id  = var.cf_zone_id
  name     = each.value.name
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1
  comment  = "Managed by Terraform"
}

# Main tunnel configuration defining ingress rules
# Routes traffic from hostnames to internal services via the tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  account_id = var.cf_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id

  config = {
    ingress = concat(
      [
        for domain in local.tunnel_dns : {
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

# Additional DNS records for other services
resource "cloudflare_dns_record" "dns_records" {
  for_each = { for domain in local.other_dns : domain.name => domain }
  zone_id  = var.cf_zone_id
  name     = each.value.name
  content  = each.value.content
  type     = each.value.type
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  comment  = "Managed by Terraform"
}
