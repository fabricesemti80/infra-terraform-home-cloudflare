# ---------------------------------------------------------------------------- #
# Docker Tunnel Local Values Configuration
# ---------------------------------------------------------------------------- #

# This file is for local values specific to the Docker tunnel
# Add Docker-specific service configurations here when needed

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
      content = "${cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id}.cfargotunnel.com"
      type    = "CNAME"
      ttl     = 1
    },
  ]
}
