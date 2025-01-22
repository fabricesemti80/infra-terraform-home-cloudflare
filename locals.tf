# Define locals for hostname, domain, and port
locals {
  domains = [
    {
      protocol = "http"
      name     = "casa"
      host     = "10.0.40.102"
      hostname = "casa.${var.cf_domain}"
      port     = 8080
    },
    {
      protocol = "http"
      name     = "it-tools"
      host     = "localhost"
      hostname = "it-tools.${var.cf_domain}"
      port     = 10010
    },
    {
      protocol = "http"
      name     = "plex"
      host     = "localhost"
      hostname = "plex.${var.cf_domain}"
      port     = 32400
    },
    {
      protocol = "http"
      name     = "portainer"
      host     = "localhost"
      hostname = "portainer.${var.cf_domain}"
      port     = 9000
    },
    {
      protocol = "http"
      name     = "nextcloud"
      host     = "localhost"
      hostname = "nextcloud.${var.cf_domain}"
      port     = 10020
    },
    {
      protocol = "http"
      name     = "overseerr"
      host     = "localhost"
      hostname = "overseerr.${var.cf_domain}"
      port     = 10030
    },
    {
      protocol = "http"
      name     = "prowlarr"
      host     = "localhost"
      hostname = "prowlarr.${var.cf_domain}"
      port     = 10040
    },
    {
      protocol = "http"
      name     = "radarr"
      host     = "localhost"
      hostname = "radarr.${var.cf_domain}"
      port     = 10050
    },
    {
      protocol = "http"
      name     = "sonarr"
      host     = "localhost"
      hostname = "sonarr.${var.cf_domain}"
      port     = 10060
    },
    {
      protocol = "http"
      name     = "sabnzbd"
      host     = "localhost"
      hostname = "sabnzbd.${var.cf_domain}"
      port     = 10070
    },
    {
      protocol = "http"
      name     = "@" #! root
      host     = "localhost"
      hostname = "${var.cf_domain}"
      port     = 10100
    },
    {
      protocol = "http"
      name     = "wallos"
      host     = "localhost"
      hostname = "wallos.${var.cf_domain}"
      port     = 10110
    }
  ]
}
