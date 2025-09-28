
/* -------------------------------------------------------------------------- */
/*                      Zero Trust Access Configurations                      */
/* -------------------------------------------------------------------------- */

# Access policy that bypasses authentication for all users
# This allows unrestricted access to the specified applications
resource "cloudflare_zero_trust_access_policy" "docker_zero_trust_access_policy" {
  account_id       = var.cf_account_id
  decision         = "bypass"
  include          = [{ everyone = {} }]
  name             = "Application Bypass TF"
  session_duration = "30m"
}

# Zero Trust applications for self-hosted services
# These applications require authentication unless bypassed by the policy above
resource "cloudflare_zero_trust_access_application" "docker_applications" {
  for_each          = local.zero_trust_applications
  zone_id           = var.cf_docker_zone_id
  name              = each.value.name
  domain            = each.value.domain
  type              = each.value.type
  session_duration  = each.value.session_duration
  skip_interstitial = each.value.skip_interstitial

  policies = [{
    id = cloudflare_zero_trust_access_policy.docker_zero_trust_access_policy.id
  }]
}

/* -------------------------------------------------------------------------- */
/*                         Docker Tunnel configuration                        */
/* -------------------------------------------------------------------------- */

# Docker Tunnel Module
module "docker_tunnel" {
  source = "./modules/cloudflare-tunnel"

  cf_account_id = var.cf_account_id
  tunnel_name   = "tf-docker-tunnel"
  config_dir    = var.config_dir

  ingress_rules = concat(
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

/* -------------------------------------------------------------------------- */
/*                       Kubernetes Tunnel configuration                      */
/* -------------------------------------------------------------------------- */

# Kubernetes Tunnel Module
module "kubernetes_tunnel" {
  source = "./modules/cloudflare-tunnel"

  cf_account_id = var.cf_account_id
  tunnel_name   = "tf-kubernetes-tunnel"
  config_dir    = var.config_dir

  ingress_rules = concat(
    [
      for domain in local.kubernetes_tunnel_dns : {
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

/* -------------------------------------------------------------------------- */
/*                          Main Tunnel configuration                         */
/* -------------------------------------------------------------------------- */

# Main tunnel for routing traffic to internal services
resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.cf_account_id
  name          = var.tunnel_name
  tunnel_secret = var.tunnel_secret

  lifecycle {
    prevent_destroy = false
  }
}
