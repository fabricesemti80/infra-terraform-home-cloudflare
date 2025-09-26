# ---------------------------------------------------------------------------- #
# Main Tunnel Configuration
# ---------------------------------------------------------------------------- #

# Main tunnel for routing traffic to internal services
resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.cf_account_id
  name          = var.tunnel_name
  tunnel_secret = var.tunnel_secret

  lifecycle {
    prevent_destroy = false
  }
}
