terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    random = {
      source = "hashicorp/random"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

# Random secret for the tunnel
resource "random_password" "tunnel_secret" {
  length  = 32
  special = false
}

# Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.cf_account_id
  name          = var.tunnel_name
  tunnel_secret = base64encode(random_password.tunnel_secret.result)

  lifecycle {
    prevent_destroy = false
  }
}

# Write tunnel credentials to local JSON file for cloudflared
resource "local_file" "tunnel_token" {
  filename = "${path.module}/../../${var.config_dir}/${var.tunnel_name}-token.json"
  content  = jsonencode({
    name          = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
    tunnel_secret = random_password.tunnel_secret.result
    account_id    = var.cf_account_id
  })
}

# Generate base64-encoded tunnel token for cloudflared authentication
resource "local_file" "cloudflared_token" {
  content  = base64encode(jsonencode({
    a = var.cf_account_id
    s = base64encode(random_password.tunnel_secret.result)
    t = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  }))
  filename = "${path.module}/../../${var.config_dir}/${var.tunnel_name}-cloudflared-token.txt"
}

# Generate tunnel configuration file with ingress rules
resource "local_file" "tunnel_config" {
  content = yamlencode({
    tunnel          = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
    credentials-file = "${path.module}/../../${var.config_dir}/${var.tunnel_name}-token.json"
    ingress         = var.ingress_rules
  })
  filename = "${path.module}/../../${var.config_dir}/${var.tunnel_name}-config.yaml"
}

# Tunnel configuration in Cloudflare
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_config" {
  account_id = var.cf_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id

  config = {
    ingress = var.ingress_rules
  }
}
