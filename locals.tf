# Define locals for hostname, domain, and port
locals {
  domains = [
    {
      protocol = "http"
      name     = "grafana"
      host     = "10.0.40.20"
      hostname = "grafana.${var.cf_domain}"
      port     = 3000
    },
        {
      protocol = "http"
      name     = "hass"
      host     = "10.0.40.21"
      hostname = "hass.${var.cf_domain}"
      port     = 8123
    },
    {
      protocol = "http"
      name     = "prometheus"
      host     = "10.0.40.20"
      hostname = "prometheus.${var.cf_domain}"
      port     = 9090
    },
    {
      protocol = "http"
      name     = "plex"
      host     = "10.0.40.2"
      hostname = "plex.${var.cf_domain}"
      port     = 32400
    },
    {
      protocol = "http"
      name     = "n8n"
      host     = "10.0.40.21"
      hostname = "n8n.${var.cf_domain}"
      port     = 5678
    },
    # {
    #   protocol = "http"
    #   name     = "nextcloud"
    #   host     = "localhost"
    #   hostname = "nextcloud.${var.cf_domain}"
    #   port     = 10020
    # },
    {
      protocol = "http"
      name     = "overseerr"
      host     = "10.0.40.20"
      hostname = "overseerr.${var.cf_domain}"
      port     = 5055
    },
    {
      protocol = "http"
      name     = "prowlarr"
      host     = "10.0.40.20"
      hostname = "prowlarr.${var.cf_domain}"
      port     = 9696
    },
    {
      protocol = "http"
      name     = "radarr"
      host     = "10.0.40.20"
      hostname = "radarr.${var.cf_domain}"
      port     = 7878
    },
    {
      protocol = "http"
      name     = "sonarr"
      host     = "10.0.40.20"
      hostname = "sonarr.${var.cf_domain}"
      port     = 8989
    },
    {
      protocol = "http"
      name     = "sabnzbd"
      host     = "10.0.40.20"
      hostname = "sabnzbd.${var.cf_domain}"
      port     = 18080
    },
    # {
    #   protocol = "http"
    #   name     = "wallos"
    #   # host     = "localhost"
    #   host = "wallos"
    #   hostname = "wallos.${var.cf_domain}"
    #   # port     = 10110
    #   port     = 80
    # },
    {
      # HomePage
      protocol = "http"
      name     = "@" #! root
      host     = "10.0.40.20"
      hostname = "${var.cf_domain}"
      port     = 11111
    },
  ]
}
