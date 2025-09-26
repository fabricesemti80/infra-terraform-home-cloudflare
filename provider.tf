terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.0.0"
    }

    hcp = {
      source = "hashicorp/hcp"
      version = "0.104.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }

  # backend "remote" {
  #   organization = "homelab-fsemti"
  #   workspaces {
  #     name = "tf-cloudflare"
  #   }
  # }

}

provider "cloudflare" {
  api_token = var.cf_api_token
}

// Credentials can be set explicitly or via the environment variables HCP_CLIENT_ID and HCP_CLIENT_SECRET
provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}
