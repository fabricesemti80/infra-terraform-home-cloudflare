
# ============================================================================ #
#                          PRIMARY TUNNEL CONFIGURATION                       #
# ============================================================================ #

# Primary Tunnel Module
module "primary_tunnel" {
  source = "./modules/cloudflare-tunnel"

  cf_account_id = var.cf_account_id
  tunnel_name   = "tf-primary-tunnel"
  config_dir    = var.config_dir

  ingress_rules = concat(
    [
      for domain in local.primary_tunnel_dns : {
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

# DNS records for primary tunnel endpoints
resource "cloudflare_dns_record" "primary_tunnel_dns_records" {
  for_each = { for domain in local.primary_tunnel_dns : domain.name => domain }
  zone_id  = var.cf_primary_zone_id
  name     = each.value.name
  content  = "${module.primary_tunnel.tunnel_id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1
  comment  = "Managed by Terraform - Primary Tunnel"
}

# Additional DNS records for primary tunnel services
resource "cloudflare_dns_record" "primary_dns_records" {
  for_each = { for domain in local.primary_other_dns : domain.name => domain }
  zone_id  = var.cf_primary_zone_id
  name     = each.value.name
  content  = each.value.content
  type     = each.value.type
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  comment  = "Managed by Terraform - Primary Tunnel Services"
}

# ============================================================================ #
#                         SECONDARY TUNNEL CONFIGURATION                      #
# ============================================================================ #

# Access policy that bypasses authentication for all users
# This allows unrestricted access to the specified applications
resource "cloudflare_zero_trust_access_policy" "secondary_zero_trust_access_policy" {
  account_id       = var.cf_account_id
  decision         = "bypass"
  include          = [{ everyone = {} }]
  name             = "Application Bypass TF"
  session_duration = "30m"
}

# Zero Trust applications for self-hosted services
# These applications require authentication unless bypassed by the policy above
resource "cloudflare_zero_trust_access_application" "secondary_applications" {
  for_each          = local.secondary_zero_trust_applications
  zone_id           = var.cf_secondary_zone_id
  name              = each.value.name
  domain            = each.value.domain
  type              = each.value.type
  session_duration  = each.value.session_duration
  skip_interstitial = each.value.skip_interstitial

  policies = [{
    id = cloudflare_zero_trust_access_policy.secondary_zero_trust_access_policy.id
  }]
}

# Secondary Tunnel Module
module "secondary_tunnel" {
  source = "./modules/cloudflare-tunnel"

  cf_account_id = var.cf_account_id
  tunnel_name   = "tf-secondary-tunnel"
  config_dir    = var.config_dir

  ingress_rules = concat(
    [
      for domain in local.secondary_tunnel_dns : {
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

# DNS records for secondary tunnel endpoints
resource "cloudflare_dns_record" "secondary_tunnel_dns_records" {
  for_each = { for domain in local.secondary_tunnel_dns : domain.name => domain }
  zone_id  = var.cf_secondary_zone_id
  name     = each.value.name
  content  = "${module.secondary_tunnel.tunnel_id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1
  comment  = "Managed by Terraform - Secondary Tunnel"
}

# Additional DNS records for secondary tunnel services
resource "cloudflare_dns_record" "secondary_dns_records" {
  for_each = { for domain in local.secondary_other_dns : domain.name => domain }
  zone_id  = var.cf_secondary_zone_id
  name     = each.value.name
  content  = each.value.content
  type     = each.value.type
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  comment  = "Managed by Terraform - Secondary Tunnel Services"
}


