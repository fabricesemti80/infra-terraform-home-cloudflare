# Docker Tunnel Module
module "docker_tunnel" {
  source = "./modules/cloudflare-tunnel"

  cf_account_id = var.cf_account_id
  tunnel_name   = "tf-docker-tunnel"
  config_dir    = var.config_dir

  ingress_rules = concat(
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
}

# Kubernetes Tunnel Module
module "kubernetes_tunnel" {
  source = "./modules/cloudflare-tunnel"

  cf_account_id = var.cf_account_id
  tunnel_name   = "tf-kubernetes-tunnel"
  config_dir    = var.config_dir

  ingress_rules = concat(
    [
      for domain in local.kubernetes_tunnel_dns : {
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
}
