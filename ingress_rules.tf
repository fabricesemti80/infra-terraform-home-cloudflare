# Define locals for hostname, domain, and port
locals {
  domains = [
    {
      name     = "casa"
      hostname = "casa.${var.cf_domain}"
      port     = 8080
    },
    {
      name     = "jelly"
      hostname = "jelly.${var.cf_domain}"
      port     = 8097
    },
    {
      name     = "jenkins"
      hostname = "jenkins.${var.cf_domain}"
      port     = 8888
    },    
    {
      name     = "nextcloud"
      hostname = "nextcloud.${var.cf_domain}"
      port     = 10081
    },
    {
      name     = "nzbget"
      hostname = "nzbget.${var.cf_domain}"
      port     = 6789
    },    

    {
      name     = "overseer"
      hostname = "overseer.${var.cf_domain}"
      port     = 5055
    },     
        {
      name     = "photoprism"
      hostname = "photoprism.${var.cf_domain}"
      port     = 2342
    },
    {
      name     = "plex"
      hostname = "plex.${var.cf_domain}"
      port     = 32400
    },
    {
      name     = "portainer"
      hostname = "portainer.${var.cf_domain}"
      port     = 9000
    },
    {
      name     = "prowlarr"
      hostname = "prowlarr.${var.cf_domain}"
      port     = 9696
    },

        {
      name     = "radarr"
      hostname = "radarr.${var.cf_domain}"
      port     = 7878
    },
    {
      name     = "sonarr"
      hostname = "sonarr.${var.cf_domain}"
      port     = 8989
    },
    {
      name     = "transmission"
      hostname = "transmission.${var.cf_domain}"
      port     = 9091
    },
    {
      name     = "trilium"
      hostname = "trilium.${var.cf_domain}"
      port     = 8088
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
