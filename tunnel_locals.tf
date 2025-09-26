# ---------------------------------------------------------------------------- #
# Main Tunnel Local Values Configuration
# ---------------------------------------------------------------------------- #

locals {
  tunnel_domain = var.cf_docker_domain
  # DNS configuration for main tunnel endpoints
  # Defines the services exposed through the main Cloudflare tunnel
  tunnel_dns = [
    {
      protocol = "http"
      name     = "@" # Root domain
      host     = "10.0.40.20"
      hostname = local.tunnel_domain
      port     = 11111
    },
    # Commented out: Atlantis service (uncomment if needed)
    # {
    #   protocol = "http"
    #   name     = "atlantis"
    #   host     = "10.0.40.21"
    #   hostname = "atlantis.${local.tunnel_domain}"
    #   port     = 4141
    # },
    {
      protocol = "http"
      name     = "grafana"
      host     = "10.0.40.20"
      hostname = "grafana.${local.tunnel_domain}"
      port     = 3000
    },
    {
      protocol = "http"
      name     = "hass"
      host     = "10.0.40.21"
      hostname = "hass.${local.tunnel_domain}"
      port     = 8123
    },
    {
      protocol = "http"
      name     = "jellyfin"
      host     = "10.0.40.20"
      hostname = "jellyfin.${local.tunnel_domain}"
      port     = 8096
    },
    {
      protocol = "http"
      name     = "jellyseerr"
      host     = "10.0.40.20"
      hostname = "jellyseerr.${local.tunnel_domain}"
      port     = 5056
    },
    {
      protocol = "http"
      name     = "kestra"
      host     = "10.0.40.21"
      hostname = "kestra.${local.tunnel_domain}"
      port     = 8080
    },
    {
      protocol = "http"
      name     = "n8n"
      host     = "10.0.40.21"
      hostname = "n8n.${local.tunnel_domain}"
      port     = 5678
    },
    {
      protocol = "http"
      name     = "overseerr"
      host     = "10.0.40.20"
      hostname = "overseerr.${local.tunnel_domain}"
      port     = 5055
    },
    {
      protocol = "http"
      name     = "plex"
      host     = "10.0.40.2"
      hostname = "plex.${local.tunnel_domain}"
      port     = 32400
    },
    {
      protocol = "http"
      name     = "prometheus"
      host     = "10.0.40.20"
      hostname = "prometheus.${local.tunnel_domain}"
      port     = 9090
    },
    {
      protocol = "http"
      name     = "prowlarr"
      host     = "10.0.40.20"
      hostname = "prowlarr.${local.tunnel_domain}"
      port     = 9696
    },
    {
      protocol = "http"
      name     = "radarr"
      host     = "10.0.40.20"
      hostname = "radarr.${local.tunnel_domain}"
      port     = 7878
    },
    {
      protocol = "http"
      name     = "sabnzbd"
      host     = "10.0.40.20"
      hostname = "sabnzbd.${local.tunnel_domain}"
      port     = 18080
    },
    {
      protocol = "http"
      name     = "sonarr"
      host     = "10.0.40.20"
      hostname = "sonarr.${local.tunnel_domain}"
      port     = 8989
    },
  ]

  # Additional DNS records not related to tunnels
  other_dns = [
    {
      name    = "external"
      proxied = true
      content = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
      type    = "CNAME"
      ttl     = 1
    },
  ]
}
