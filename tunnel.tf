# ---------------------------------------------------------------------------- #
# Tunnel Configuration
# ---------------------------------------------------------------------------- #

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.cf_account_id
  name          = var.tunnel_name
  tunnel_secret = var.tunnel_secret

  lifecycle {
    prevent_destroy = false
  }
}

# Random secrets for the new tunnels
resource "random_password" "docker_tunnel_secret" {
  length  = 32
  special = false
}

resource "random_password" "kubernetes_tunnel_secret" {
  length  = 32
  special = false
}

# Docker tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "docker_tunnel" {
  account_id    = var.cf_account_id
  name          = "tf-docker-tunnel"
  tunnel_secret = base64encode(random_password.docker_tunnel_secret.result)

  lifecycle {
    prevent_destroy = false
  }
}

# Kubernetes tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "kubernetes_tunnel" {
  account_id    = var.cf_account_id
  name          = "tf-kubernetes-tunnel"
  tunnel_secret = base64encode(random_password.kubernetes_tunnel_secret.result)

  lifecycle {
    prevent_destroy = false
  }
}

# Write tunnel tokens to config files
resource "local_file" "docker_tunnel_token" {
  filename = "${path.module}/${var.config_dir}/docker-tunnel-token.json"
  content  = jsonencode({
    name          = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.name
    tunnel_secret = random_password.docker_tunnel_secret.result
    account_id    = var.cf_account_id
  })
}

resource "local_file" "kubernetes_tunnel_token" {
  filename = "${path.module}/${var.config_dir}/kubernetes-tunnel-token.json"
  content  = jsonencode({
    name          = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.name
    tunnel_secret = random_password.kubernetes_tunnel_secret.result
    account_id    = var.cf_account_id
  })
}

# Generate proper tunnel tokens (base64 encoded JSON)
resource "local_file" "docker_cloudflared_token" {
  content  = base64encode(jsonencode({
    a = var.cf_account_id
    s = base64encode(random_password.docker_tunnel_secret.result)
    t = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id
  }))
  filename = "${path.module}/${var.config_dir}/docker-cloudflared-token.txt"
}

resource "local_file" "kubernetes_cloudflared_token" {
  content  = base64encode(jsonencode({
    a = var.cf_account_id
    s = base64encode(random_password.kubernetes_tunnel_secret.result)
    t = cloudflare_zero_trust_tunnel_cloudflared.kubernetes_tunnel.id
  }))
  filename = "${path.module}/${var.config_dir}/kubernetes-cloudflared-token.txt"
}
