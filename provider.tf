# ---------------------------------------------------------------------------- #
# Terraform Configuration
# ---------------------------------------------------------------------------- #

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.0.0"
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

  # Remote backend configuration for Terraform Cloud
  # Uncomment and configure for remote state management
  # backend "remote" {
  #   organization = "homelab-fsemti"
  #   workspaces {
  #     name = "tf-cloudflare"
  #   }
  # }
}

# ---------------------------------------------------------------------------- #
# Provider Configurations
# ---------------------------------------------------------------------------- #

# Cloudflare provider configuration
provider "cloudflare" {
  api_token = var.cf_api_token
}
