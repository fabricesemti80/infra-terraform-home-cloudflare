#------------------------------------------------------------------------------
# General Variables
#------------------------------------------------------------------------------

variable "cf_account_id" {
  description = "Cloudflare account ID"
  type        = string
  sensitive = false
}

variable "cf_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
  sensitive = false
}

variable "cf_domain" {
  description = "Base domain for Cloudflare"
  type        = string
  sensitive = false
}

variable "cf_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive = tru
}

variable "tunnel_secret" {
  description = "Secret for the Cloudflare tunnel"
  type        = string
  sensitive = true
}

#------------------------------------------------------------------------------
# Tunnel Configuration Variables
#------------------------------------------------------------------------------

variable "tunnel_name" {
  description = "Name of the Cloudflare tunnel"
  type        = string
  default     = "terraformed-docker-tunnel"
  sensitive = false
}

variable "credentials_file_path" {
  description = "Path to store tunnel credentials files"
  type        = string
  default     = "~/.cloudflared"
  sensitive = false
}

#------------------------------------------------------------------------------
# Application Configuration Variables
#------------------------------------------------------------------------------

# variable "hass_domain" {
#  description = "Domain for Home Assistant application"
#   type        = string
#   default     = "hass.example.com"
# }

#------------------------------------------------------------------------------
# Zero Trust Variables
#------------------------------------------------------------------------------

# variable "tf_token_app_terraform_io" {
#   description = "Token for Terraform Cloud or Enterprise"
#   type        = string
# }
