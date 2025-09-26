# ---------------------------------------------------------------------------- #
# Kubernetes Tunnel Output Values
# ---------------------------------------------------------------------------- #

output "kubernetes_tunnel_id" {
  description = "ID of the Kubernetes Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id
}

output "kubernetes_tunnel_name" {
  description = "Name of the Kubernetes Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.name
}
