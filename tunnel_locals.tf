# ---------------------------------------------------------------------------- #
# Main Tunnel Local Values Configuration
# ---------------------------------------------------------------------------- #

locals {
  tunnel_domain = var.cf_docker_domain
  # DNS configuration for main tunnel endpoints
  # Defines the services exposed through the main Cloudflare tunnel
  tunnel_dns = []

  # Additional DNS records not related to tunnels
  other_dns = []
}
