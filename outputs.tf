 /* -------------------------------------------------------------------------- */
 /*                             Main Tunnel outputs                            */
 /* -------------------------------------------------------------------------- */


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
    docker     = module.docker_tunnel.tunnel_id
    portainer = module.portainer_tunnel.tunnel_id
  }
}

/* -------------------------------------------------------------------------- */
/*                            Docker Tunnel Outputs                           */
/* -------------------------------------------------------------------------- */
output "docker_tunnel_id" {
  description = "ID of the Docker Cloudflare Tunnel"
  value       = module.docker_tunnel.tunnel_id
}

output "docker_tunnel_name" {
  description = "Name of the Docker Cloudflare Tunnel"
  value       = module.docker_tunnel.tunnel_name
}

output "docker_tunnel_config_content" {
  description = "YAML content for the Docker tunnel configuration file"
  value       = module.docker_tunnel.tunnel_config_content
}

/* -------------------------------------------------------------------------- */
/*                          Kubernetes Tunnel outputs                         */
/* -------------------------------------------------------------------------- */
output "portainer_tunnel_id" {
  description = "ID of the Kubernetes Cloudflare Tunnel"
  value       = module.portainer_tunnel.tunnel_id
}

output "portainer_tunnel_name" {
  description = "Name of the Kubernetes Cloudflare Tunnel"
  value       = module.portainer_tunnel.tunnel_name
}

output "portainer_tunnel_config_content" {
  description = "YAML content for the Kubernetes tunnel configuration file"
  value       = module.portainer_tunnel.tunnel_config_content
}
