# ---------------------------------------------------------------------------- #
# Main Tunnel Output Values
# ---------------------------------------------------------------------------- #

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
