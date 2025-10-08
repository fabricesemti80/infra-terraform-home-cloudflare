# ============================================================================ #
#                          PRIMARY TUNNEL OUTPUTS                            #
# ============================================================================ #

output "primary_tunnel_id" {
  description = "ID of the primary Cloudflare Tunnel"
  value       = module.primary_tunnel.tunnel_id
}

output "primary_tunnel_name" {
  description = "Name of the primary Cloudflare Tunnel"
  value       = module.primary_tunnel.tunnel_name
}

output "primary_tunnel_config_content" {
  description = "YAML content for the primary tunnel configuration file"
  value       = module.primary_tunnel.tunnel_config_content
}

# ============================================================================ #
#                         SECONDARY TUNNEL OUTPUTS                           #
# ============================================================================ #

output "secondary_tunnel_id" {
  description = "ID of the secondary Cloudflare Tunnel"
  value       = module.secondary_tunnel.tunnel_id
}

output "secondary_tunnel_name" {
  description = "Name of the secondary Cloudflare Tunnel"
  value       = module.secondary_tunnel.tunnel_name
}

output "secondary_tunnel_config_content" {
  description = "YAML content for the secondary tunnel configuration file"
  value       = module.secondary_tunnel.tunnel_config_content
}



# ============================================================================ #
#                            COMBINED OUTPUTS                                #
# ============================================================================ #

output "all_tunnel_ids" {
  description = "Map of all tunnel IDs by tunnel type"
  value = {
    primary   = module.primary_tunnel.tunnel_id
    secondary = module.secondary_tunnel.tunnel_id
  }
}
