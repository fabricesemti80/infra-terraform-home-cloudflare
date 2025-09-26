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
    # Example:
    # {
    #   protocol = "http"
    #   name     = "docker-service"
    #   host     = "docker-host"
    #   hostname = "service.${local.docker_domain}"
    #   port     = 8080
    # }
  ]

  # Additional Docker-specific DNS records
  docker_other_dns = [
    # Add any additional DNS records for Docker services here
  ]
}
