# ---------------------------------------------------------------------------- #
# Docker Tunnel Output Values
# ---------------------------------------------------------------------------- #

output "docker_tunnel_id" {
  description = "ID of the Docker Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id
}

output "docker_tunnel_name" {
  description = "Name of the Docker Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.name
}
