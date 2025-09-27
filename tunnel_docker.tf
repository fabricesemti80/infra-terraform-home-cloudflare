# ---------------------------------------------------------------------------- #
# Docker Tunnel Configuration
# ---------------------------------------------------------------------------- #

# Random secret for the Docker tunnel
resource "random_password" "docker_tunnel_secret" {
  length  = 32
  special = false
}

# Docker tunnel for containerized services
resource "cloudflare_zero_trust_tunnel_cloudflared" "docker_tunnel" {
  account_id    = var.cf_account_id
  name          = "tf-docker-tunnel"
  tunnel_secret = base64encode(random_password.docker_tunnel_secret.result)

  lifecycle {
    prevent_destroy = false
  }
}

# ---------------------------------------------------------------------------- #
# Docker Tunnel Token Files
# ---------------------------------------------------------------------------- #

# Write Docker tunnel credentials to local JSON file for cloudflared
resource "local_file" "docker_tunnel_token" {
  filename = "${path.module}/${var.config_dir}/docker-tunnel-token.json"
  content  = jsonencode({
    name          = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.name
    tunnel_secret = random_password.docker_tunnel_secret.result
    account_id    = var.cf_account_id
  })
}

# Generate base64-encoded Docker tunnel token for cloudflared authentication
resource "local_file" "docker_cloudflared_token" {
  content  = base64encode(jsonencode({
    a = var.cf_account_id
    s = base64encode(random_password.docker_tunnel_secret.result)
    t = cloudflare_zero_trust_tunnel_cloudflared.docker_tunnel.id
  }))
  filename = "${path.module}/${var.config_dir}/docker-cloudflared-token.txt"
}

# Generate Docker tunnel configuration file with ingress rules
resource "local_file" "docker_tunnel_config" {
  content = yamlencode({
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
  filename = "${path.module}/${var.config_dir}/docker-tunnel-config.yaml"
}
