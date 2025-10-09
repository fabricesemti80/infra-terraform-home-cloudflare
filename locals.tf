


locals {

  # ============================================================================ #
  #                          PRIMARY TUNNEL CONFIGURATION                        #
  # ============================================================================ #

  primary_tunnel_domain = var.cf_primary_domain

  # Primary tunnel DNS configuration
  # Define Portainer/Kubernetes services to be exposed through the primary tunnel
  primary_tunnel_ingress = [
    # Example:
    # {
    #   protocol = "http"
    #   name     = "k8s-service"
    #   host     = "portainer-service"
    #   hostname = "k8s-service.${local.primary_tunnel_domain}"
    #   port     = 8080
    # }
    {
      # http://homepage:3000
      protocol = "http"
      name     = "homepage"
      host     = "homepage"
      hostname = "homepage.${local.primary_tunnel_domain}"
      port     = 3000
    },
    {
      # http://sonarr:8989
      protocol = "http"
      name     = "sonarr"
      host     = "sonarr"
      hostname = "sonarr.${local.primary_tunnel_domain}"
      port     = 8989
    },
    {
      # http://overseerr:5055
      protocol = "http"
      name     = "overseerr"
      host     = "overseerr"
      hostname = "overseerr.${local.primary_tunnel_domain}"
      port     = 5055
    },
    {
      # http://radarr:7878
      protocol = "http"
      name     = "radarr"
      host     = "radarr"
      hostname = "radarr.${local.primary_tunnel_domain}"
      port     = 7878
    }
  ]

  # Additional primary tunnel-specific DNS records
  primary_other_dns = [
    # Add any additional DNS records for primary tunnel services here
  ]

  # ============================================================================ #
  #                         SECONDARY TUNNEL CONFIGURATION                      #
  # ============================================================================ #

  secondary_tunnel_domain = var.cf_secondary_domain

  # Secondary tunnel DNS configuration
  # Define Docker services to be exposed through the secondary tunnel
  secondary_tunnel_ingress = [
    {
      protocol = "http"
      name     = "@" # Root domain
      host     = "10.0.40.20"
      hostname = local.secondary_tunnel_domain
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
      hostname = "grafana.${local.secondary_tunnel_domain}"
      port     = 3000
    },
    {
      protocol = "http"
      name     = "hass"
      host     = "10.0.40.21"
      hostname = "hass.${local.secondary_tunnel_domain}"
      port     = 8123
    },
    {
      protocol = "http"
      name     = "jellyfin"
      host     = "10.0.40.20"
      hostname = "jellyfin.${local.secondary_tunnel_domain}"
      port     = 8096
    },
    {
      protocol = "http"
      name     = "jellyseerr"
      host     = "10.0.40.20"
      hostname = "jellyseerr.${local.secondary_tunnel_domain}"
      port     = 5056
    },
    {
      protocol = "http"
      name     = "kestra"
      host     = "10.0.40.21"
      hostname = "kestra.${local.secondary_tunnel_domain}"
      port     = 8080
    },
    {
      protocol = "http"
      name     = "n8n"
      host     = "10.0.40.21"
      hostname = "n8n.${local.secondary_tunnel_domain}"
      port     = 5678
    },
    {
      protocol = "http"
      name     = "overseerr"
      host     = "10.0.40.20"
      hostname = "overseerr.${local.secondary_tunnel_domain}"
      port     = 5055
    },
    {
      protocol = "http"
      name     = "plex"
      host     = "10.0.40.2"
      hostname = "plex.${local.secondary_tunnel_domain}"
      port     = 32400
    },
    {
      protocol = "http"
      name     = "prometheus"
      host     = "10.0.40.20"
      hostname = "prometheus.${local.secondary_tunnel_domain}"
      port     = 9090
    },
    {
      protocol = "http"
      name     = "prowlarr"
      host     = "10.0.40.20"
      hostname = "prowlarr.${local.secondary_tunnel_domain}"
      port     = 9696
    },
    {
      protocol = "http"
      name     = "radarr"
      host     = "10.0.40.20"
      hostname = "radarr.${local.secondary_tunnel_domain}"
      port     = 7878
    },
    {
      protocol = "http"
      name     = "sabnzbd"
      host     = "10.0.40.20"
      hostname = "sabnzbd.${local.secondary_tunnel_domain}"
      port     = 18080
    },
    {
      protocol = "http"
      name     = "sonarr"
      host     = "10.0.40.20"
      hostname = "sonarr.${local.secondary_tunnel_domain}"
      port     = 8989
    },
  ]

  # Additional secondary tunnel-specific DNS records
  secondary_other_dns = [
    {
      name    = "external"
      proxied = true
      content = "${module.secondary_tunnel.tunnel_id}.cfargotunnel.com"
      type    = "CNAME"
      ttl     = 1
    },
  ]

  # Zero Trust Applications Configuration for secondary tunnel services
  # Services that require authentication through Cloudflare Access
  secondary_zero_trust_applications = {
    # atlantis = {
    #   name              = "Atlantis"
    #   domain            = "atlantis.${var.cf_secondary_domain}"
    #   type              = "self_hosted"
    #   session_duration  = "24h"
    #   skip_interstitial = true
    # },
    # hass = {
    #   name              = "Home Assistant"
    #   domain            = "hass.${var.cf_secondary_domain}"
    #   type              = "self_hosted"
    #   session_duration  = "24h"
    #   skip_interstitial = true
    # },
    jellyfin = {
      name              = "Jellyfin"
      domain            = "jellyfin.${var.cf_secondary_domain}"
      type              = "self_hosted"
      session_duration  = "24h"
      skip_interstitial = true
    },
  }
}


