output "tunnel_id" {
  description = "ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_name" {
  description = "Name of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
}

output "tunnel_config_content" {
  description = "YAML content for the tunnel configuration file"
  value = yamlencode({
    tunnel          = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    credentials-file = "${path.module}/${var.config_dir}/${var.tunnel_name}-token.json"
    ingress         = var.ingress_rules
  })
}
