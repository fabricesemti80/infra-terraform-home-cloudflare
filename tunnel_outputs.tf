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

output "all_tunnel_ids" {
  description = "Map of all tunnel IDs by tunnel type"
  value = {
    main       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    docker     = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id
    kubernetes = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id
  }
}
