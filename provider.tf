terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.41.0"
    }
  }

  backend "remote" {
    organization = "homelab-fsemti"
    workspaces {
      name = "tf-cloudflare"
    }
  }

}

provider "cloudflare" {
  api_token = var.cf_api_token
}
