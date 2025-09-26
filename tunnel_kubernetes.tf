# ---------------------------------------------------------------------------- #
# Kubernetes Tunnel Configuration
# ---------------------------------------------------------------------------- #

# Random secret for the Kubernetes tunnel
resource "random_password" "kubernetes_tunnel_secret" {
  length  = 32
  special = false
}

# Kubernetes tunnel for cluster services
resource "cloudflare_zero_trust_tunnel_cloudflared" "kubernetes_tunnel" {
  account_id    = var.cf_account_id
  name          = "tf-kubernetes-tunnel"
  tunnel_secret = base64encode(random_password.kubernetes_tunnel_secret.result)

  lifecycle {
    prevent_destroy = false
  }
}

# ---------------------------------------------------------------------------- #
# Kubernetes Tunnel Token Files
# ---------------------------------------------------------------------------- #

# Write Kubernetes tunnel credentials to local JSON file for cloudflared
resource "local_file" "kubernetes_tunnel_token" {
  filename = "${path.module}/${var.config_dir}/kubernetes-tunnel-token.json"
  content  = jsonencode({
    name          = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.name
    tunnel_secret = random_password.kubernetes_tunnel_secret.result
    account_id    = var.cf_account_id
  })
}

# Generate base64-encoded Kubernetes tunnel token for cloudflared authentication
resource "local_file" "kubernetes_cloudflared_token" {
  content  = base64encode(jsonencode({
    a = var.cf_account_id
    s = base64encode(random_password.kubernetes_tunnel_secret.result)
    t = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id
  }))
  filename = "${path.module}/${var.config_dir}/kubernetes-cloudflared-token.txt"
}
