# This file has been split into tunnel-specific local files:
# - tunnel_locals.tf: Main tunnel local values
# - docker_locals.tf: Docker tunnel local values
# - kubernetes_locals.tf: Kubernetes tunnel local values

# Zero Trust applications configuration
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
