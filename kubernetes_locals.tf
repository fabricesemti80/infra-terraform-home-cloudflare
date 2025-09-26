# ---------------------------------------------------------------------------- #
# Kubernetes Tunnel Local Values Configuration
# ---------------------------------------------------------------------------- #

# This file is for local values specific to the Kubernetes tunnel
# Add Kubernetes-specific service configurations here when needed

locals {
  kubernetes_domain = var.cf_docker_domain

  # Kubernetes tunnel DNS configuration
  # Define Kubernetes services to be exposed through the Kubernetes tunnel
  kubernetes_tunnel_dns = [
    # Example:
    # {
    #   protocol = "http"
    #   name     = "k8s-service"
    #   host     = "kubernetes-service"
    #   hostname = "k8s-service.${local.kuberenetes_domain}"
    #   port     = 8080
    # }
  ]

  # Additional Kubernetes-specific DNS records
  kubernetes_other_dns = [
    # Add any additional DNS records for Kubernetes services here
  ]
}
