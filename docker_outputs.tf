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

output "docker_tunnel_config_content" {
  description = "YAML content for the Docker tunnel configuration file"
  value = yamlencode({
    tunnel          = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id
    credentials-file = "${path.module}/${var.config_dir}/docker-tunnel-token.json"
    ingress = concat(
      [
        for domain in local.docker_tunnel_dns : {
          hostname = domain.hostname
          service  = "${domain.protocol}://${domain.host}:${domain.port}"
        }
      ],
      [
        {
          service = "http_status:404"
        }
      ]
    )
  })
}
