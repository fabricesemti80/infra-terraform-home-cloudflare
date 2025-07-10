# ---------------------------------------------------------------------------- #
# Tunnel Configuration
# ---------------------------------------------------------------------------- #

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.cf_account_id
  name          = var.tunnel_name
  tunnel_secret = var.tunnel_secret

  lifecycle {
    prevent_destroy = true
  }
}

resource "hcp_vault_secrets_secret" "tunnel_credential" {
  app_name    = var.hcp_secret_app_name
  secret_name = replace("${var.tunnel_name}_credential", "-", "_")
  secret_value = jsonencode({
    AccountTag   = var.cf_account_id
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    TunnelName   = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
    TunnelSecret = var.tunnel_secret
  })
}
