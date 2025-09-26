# ---------------------------------------------------------------------------- #
# Output Values
# ---------------------------------------------------------------------------- #

# Main tunnel outputs
output "tunnel_id" {
  description = "ID of the main Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_name" {
  description = "Name of the main Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
}

output "tunnel_config_content" {
  value = yamlencode({
    tunnel           = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    credentials-file = "~/.cloudflared/${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.json"
  })
  description = "YAML content for the main tunnel configuration file"
}

# Docker tunnel outputs
output "docker_tunnel_id" {
  description = "ID of the Docker Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id
}

output "docker_tunnel_name" {
  description = "Name of the Docker Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.name
}

# Kubernetes tunnel outputs
output "kubernetes_tunnel_id" {
  description = "ID of the Kubernetes Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id
}

output "kubernetes_tunnel_name" {
  description = "Name of the Kubernetes Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.name
}
