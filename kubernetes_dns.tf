# ---------------------------------------------------------------------------- #
# Kubernetes Tunnel DNS Records and Configuration
# ---------------------------------------------------------------------------- #

# This file contains DNS records and configuration for the Kubernetes tunnel
# Add Kubernetes-specific DNS resources here when services are defined

# DNS records for Kubernetes tunnel endpoints
# Uncomment and modify when kubernetes_tunnel_dns locals are defined
# resource "cloudflare_dns_record" "kubernetes_tunnel_dns_records" {
#   for_each = { for domain in local.kubernetes_tunnel_dns : domain.name => domain }
#   zone_id  = var.cf_docker_zone_id
#   name     = each.value.name
#   content  = "${cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id}.cfargotunnel.com"
#   type     = "CNAME"
#   proxied  = true
#   ttl      = 1
#   comment  = "Managed by Terraform - Kubernetes Tunnel"
# }

# Kubernetes tunnel configuration defining ingress rules
# Uncomment and modify when kubernetes_tunnel_dns locals are defined
# resource "cloudflare_zero_trust_tunnel_cloudflared_config" "kubernetes_tunnel_config" {
#   account_id = var.cf_account_id
#   tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id
#
#   config = {
#     ingress = concat(
#       [
#         for domain in local.kubernetes_tunnel_dns : {
#           hostname = domain.hostname
#           service  = "${domain.protocol}://${domain.host}:${domain.port}"
#         }
#       ],
#       [
#         {
#           service = "http_status:404"
#         }
#       ]
#     )
#   }
# }

# Additional DNS records for Kubernetes services
# Uncomment and modify when kubernetes_other_dns locals are defined
# resource "cloudflare_dns_record" "kubernetes_dns_records" {
#   for_each = { for domain in local.kubernetes_other_dns : domain.name => domain }
#   zone_id  = var.cf_docker_zone_id
#   name     = each.value.name
#   content  = each.value.content
#   type     = each.value.type
#   proxied  = each.value.proxied
#   ttl      = each.value.ttl
#   comment  = "Managed by Terraform - Kubernetes Services"
# }
