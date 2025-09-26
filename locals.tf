# ---------------------------------------------------------------------------- #
# Local Values Configuration
# ---------------------------------------------------------------------------- #

locals {
  # DNS configuration for tunnel endpoints
  # Defines the services exposed through the Cloudflare tunnel
  tunnel_dns = [
    {
      protocol = "http"
      name     = "@" # Root domain
      host     = "10.0.40.20"
      hostname = var.cf_docker_domain
      port     = 11111
    },
    # Commented out: Atlantis service (uncomment if needed)
    # {
    #   protocol = "http"
    #   name     = "atlantis"
    #   host     = "10.0.40.21"
    #   hostname = "atlantis.${var.cf_docker_domain}"
    #   port     = 4141
    # },
    {
      protocol = "http"
      name     = "grafana"
      host     = "10.0.40.20"
      hostname = "grafana.${var.cf_docker_domain}"
      port     = 3000
    },
    {
      protocol = "http"
      name     = "hass"
      host     = "10.0.40.21"
      hostname = "hass.${var.cf_docker_domain}"
      port     = 8123
    },
    {
      protocol = "http"
      name     = "jellyfin"
      host     = "10.0.40.20"
      hostname = "jellyfin.${var.cf_docker_domain}"
      port     = 8096
    },
    {
      protocol = "http"
      name     = "jellyseerr"
      host     = "10.0.40.20"
      hostname = "jellyseerr.${var.cf_docker_domain}"
      port     = 5056
    },
    {
      protocol = "http"
      name     = "kestra"
      host     = "10.0.40.21"
      hostname = "kestra.${var.cf_docker_domain}"
      port     = 8080
    },
    {
      protocol = "http"
      name     = "n8n"
      host     = "10.0.40.21"
      hostname = "n8n.${var.cf_docker_domain}"
      port     = 5678
    },
    {
      protocol = "http"
      name     = "overseerr"
      host     = "10.0.40.20"
      hostname = "overseerr.${var.cf_docker_domain}"
      port     = 5055
    },
    {
      protocol = "http"
      name     = "plex"
      host     = "10.0.40.2"
      hostname = "plex.${var.cf_docker_domain}"
      port     = 32400
    },
    {
      protocol = "http"
      name     = "prometheus"
      host     = "10.0.40.20"
      hostname = "prometheus.${var.cf_docker_domain}"
      port     = 9090
    },
    {
      protocol = "http"
      name     = "prowlarr"
      host     = "10.0.40.20"
      hostname = "prowlarr.${var.cf_docker_domain}"
      port     = 9696
    },
    {
      protocol = "http"
      name     = "radarr"
      host     = "10.0.40.20"
      hostname = "radarr.${var.cf_docker_domain}"
      port     = 7878
    },
    {
      protocol = "http"
      name     = "sabnzbd"
      host     = "10.0.40.20"
      hostname = "sabnzbd.${var.cf_docker_domain}"
      port     = 18080
    },
    {
      protocol = "http"
      name     = "sonarr"
      host     = "10.0.40.20"
      hostname = "sonarr.${var.cf_docker_domain}"
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

  # Zero Trust applications configuration
  # Services that require authentication through Cloudflare Access
  zero_trust_applications = {
    atlantis = {
      name             = "Atlantis"
      domain           = "atlantis.${var.cf_docker_domain}"
      type             = "self_hosted"
      session_duration = "24h"
      skip_interstitial = true
    },
    hass = {
      name             = "Home Assistant"
      domain           = "hass.${var.cf_docker_domain}"
      type             = "self_hosted"
      session_duration = "24h"
      skip_interstitial = true
    },
    jellyfin = {
      name             = "Jellyfin"
      domain           = "jellyfin.${var.cf_docker_domain}"
      type             = "self_hosted"
      session_duration = "24h"
      skip_interstitial = true
    },
  }
}
