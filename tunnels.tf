# Define the tunnel resource
#? Import it with "terraform import cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel ${TF_VAR_cf_account_id}/ea8ef032-4e1b-408d-ba6d-abd101a6d54c"
#? $ terraform import cloudflare_zero_trust_tunnel_cloudflared.example <cf_account_id>/<tunnel_id>
# Define the tunnel resource and import it
resource "cloudflare_zero_trust_tunnel_cloudflared" "existing_tunnel" {
  account_id = var.cf_account_id
  name       = "docker-tunnel-new"
  secret     = var.tunnel_secret_docker
}
# Outputs for Cloudflare configuration
output "tunnel_id" {
  description = "ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
}
output "tunnel_name" {
  description = "Name of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.name
}
output "credentials_json" {
  description = "JSON credentials content for ~/.cloudflared/<TUNNEL_ID>.json"
  sensitive   = true
  value = jsonencode({
    AccountTag   = var.cf_account_id
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
    TunnelName   = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.name
    TunnelSecret = var.tunnel_secret_docker
  })
}
# output "config_yaml" {
#   description = "YAML configuration for ~/.cloudflared/config.yaml"
#   value       = yamlencode({
#     tunnel            = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id
#     credentials-file  = "~/.cloudflared/${cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.id}.json"
#     ingress = [
#       for domain in local.domains : {
#         hostname = domain.hostname
#         service  = "http://localhost:${domain.port}"
#       },
#       {
#         service = "http_status:404" # Default catch-all rule
#       }
#     ]
#   })s
# }
output "tunnel_token" {
  description = "Tunnel token for cloudflared"
  sensitive   = true
  value       = cloudflare_zero_trust_tunnel_cloudflared.existing_tunnel.tunnel_token
}
