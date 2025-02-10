
/* -------------------------------------------------------------------------- */
/*                                Tunnel config                               */
/* -------------------------------------------------------------------------- */

resource "random_password" "tunnel_secret" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.cf_account_id
  name          = "terraformed-docker-tunnel"
  tunnel_secret = random_password.tunnel_secret.result
}

output "tunnel_id" {
  description = "ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_name" {
  description = "Name of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
}

# Tunnel credentials stored locally

resource "local_file" "tunnel_credentials" {
  # count = terraform.workspace == "default" ? 1 : 0 #! Add a condition to only create them when running locally using the terraform.workspace check
  content = jsonencode({
    AccountTag   = var.cf_account_id
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    TunnelName   = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
    TunnelSecret = random_password.tunnel_secret.result
  })
  filename = pathexpand("~/.cloudflared/${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.json")
}

resource "local_file" "tunnel_config" {
  # count = terraform.workspace == "default" ? 1 : 0 #! Add a condition to only create them when running locally using the terraform.workspace check
  content = yamlencode({
    tunnel           = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    credentials-file = "~/.cloudflared/${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.json"
  })
  filename = pathexpand("~/.cloudflared/config.yaml")
}

/* ---------------------------------------------------------------------------------------- */
/*                 # Add DNS records and ingresses for each subdomain entry                 */
/* -------------------------------------------------------------------------- ------------- */

resource "cloudflare_dns_record" "tunnel_dns_records" {
  for_each = { for domain in local.tunnel_dns : domain.name => domain }
  zone_id  = var.cf_zone_id
  name     = each.value.name
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1 # Auto-managed
  comment  = "Managed by Terraform"
}


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

/* -------------------------------------------------------------------------- */
/*                           Standalone DNS records                           */
/* -------------------------------------------------------------------------- */
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


/* -------------------------------------------------------------------------- */
/*                      Application Access Configurations                     */
/* -------------------------------------------------------------------------- */


# Create a specific application for Home Assistant that bypasses authentication
resource "cloudflare_zero_trust_access_policy" "example_zero_trust_access_policy" {
account_id = var.cf_account_id
decision = "bypass" # Valid values are: "allow", "deny", "non_identity", "bypass"
include = [{
everyone = {}
}]
name = "Application Bypass"
session_duration = "30m"
}


# Create a specific application for Home Assistant that bypasses authentication
resource "cloudflare_zero_trust_access_application" "hass" {
zone_id = var.cf_zone_id
name = "Home Assistant"
domain = "hass.fabricesemti.dev"
type = "self_hosted"
session_duration = "24h"
skip_interstitial = true


# policies = [{
# id =cloudflare_zero_trust_access_policy.example_zero_trust_access_policy .id
# precedence = 0
# }]


depends_on = [
cloudflare_zero_trust_access_policy.example_zero_trust_access_policy
]
}