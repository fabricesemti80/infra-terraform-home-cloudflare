# ============================================================================ #
# Docker Tunnel Local Values Configuration
# ============================================================================ #

locals {
  docker_domain = var.cf_docker_domain

  # Docker tunnel DNS configuration
  # Define Docker services to be exposed through the Docker tunnel
  docker_tunnel_dns = [
    {
      protocol = "http"
      name     = "@" # Root domain
      host     = "10.0.40.20"
      hostname = local.docker_domain
      port     = 11111
    },
    # Commented out: Atlantis service (uncomment if needed)
    # {
    #   protocol = "http"
    #   name     = "atlantis"
    #   host     = "10.0.40.21"
    #   hostname = "atlantis.${local.docker_domain}"
    #   port     = 4141
    # },
    {
      protocol = "http"
      name     = "grafana"
      host     = "10.0.40.20"
      hostname = "grafana.${local.docker_domain}"
      port     = 3000
    },
    {
      protocol = "http"
      name     = "hass"
      host     = "10.0.40.21"
      hostname = "hass.${local.docker_domain}"
      port     = 8123
    },
    {
      protocol = "http"
      name     = "jellyfin"
      host     = "10.0.40.20"
      hostname = "jellyfin.${local.docker_domain}"
      port     = 8096
    },
    {
      protocol = "http"
      name     = "jellyseerr"
      host     = "10.0.40.20"
      hostname = "jellyseerr.${local.docker_domain}"
      port     = 5056
    },
    {
      protocol = "http"
      name     = "kestra"
      host     = "10.0.40.21"
      hostname = "kestra.${local.docker_domain}"
      port     = 8080
    },
    {
      protocol = "http"
      name     = "n8n"
      host     = "10.0.40.21"
      hostname = "n8n.${local.docker_domain}"
      port     = 5678
    },
    {
      protocol = "http"
      name     = "overseerr"
      host     = "10.0.40.20"
      hostname = "overseerr.${local.docker_domain}"
      port     = 5055
    },
    {
      protocol = "http"
      name     = "plex"
      host     = "10.0.40.2"
      hostname = "plex.${local.docker_domain}"
      port     = 32400
    },
    {
      protocol = "http"
      name     = "prometheus"
      host     = "10.0.40.20"
      hostname = "prometheus.${local.docker_domain}"
      port     = 9090
    },
    {
      protocol = "http"
      name     = "prowlarr"
      host     = "10.0.40.20"
      hostname = "prowlarr.${local.docker_domain}"
      port     = 9696
    },
    {
      protocol = "http"
      name     = "radarr"
      host     = "10.0.40.20"
      hostname = "radarr.${local.docker_domain}"
      port     = 7878
    },
    {
      protocol = "http"
      name     = "sabnzbd"
      host     = "10.0.40.20"
      hostname = "sabnzbd.${local.docker_domain}"
      port     = 18080
    },
    {
      protocol = "http"
      name     = "sonarr"
      host     = "10.0.40.20"
      hostname = "sonarr.${local.docker_domain}"
      port     = 8989
    },
  ]

  # Additional Docker-specific DNS records
  docker_other_dns = [
    {
      name    = "external"
      proxied = true
      content = "${module.docker_tunnel.tunnel_id}.cfargotunnel.com"
      type    = "CNAME"
      ttl     = 1
    },
  ]
}

# ============================================================================ #
# Zero Trust Applications Configuration
# ============================================================================ #

# Services that require authentication through Cloudflare Access
locals {
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

# ============================================================================ #
# Main Tunnel Local Values Configuration
# ============================================================================ #

locals {
  tunnel_domain = var.cf_docker_domain
  # DNS configuration for main tunnel endpoints
  # Defines the services exposed through the main Cloudflare tunnel
  tunnel_dns = []

  # Additional DNS records not related to tunnels
  other_dns = []
}
