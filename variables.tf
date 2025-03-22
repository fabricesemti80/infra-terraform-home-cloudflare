# ---------------------------------------------------------------------------- #
# Cloudflare Configuration Variables
# ---------------------------------------------------------------------------- #

variable "cf_account_id" {
  description = "The ID of the Cloudflare account."
  type        = string
}

variable "cf_zone_id" {
  description = "The ID of the Cloudflare zone."
  type        = string
}

variable "cf_domain" {
  description = "The base domain managed by Cloudflare."
  type        = string
}

variable "cf_api_token" {
  description = "API token for authenticating with Cloudflare."
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------- #
# Tunnel Configuration Variables
# ---------------------------------------------------------------------------- #

variable "tunnel_name" {
  description = "The name assigned to the Cloudflare tunnel."
  type        = string
  default     = "terraformed-docker-tunnel"
}

variable "tunnel_secret" {
  description = "Secret key for the Cloudflare tunnel."
  type        = string
  sensitive   = true
}

variable "terraformed_docker_tunnel_config" {
  description = "Configuration for the Terraformed Docker tunnel."
  type        = string
  default = ""
}

variable "terraformed_docker_tunnel_credential" {
  description = "Credential for the Terraformed Docker tunnel."
  type        = string
  default = ""
}

# ---------------------------------------------------------------------------- #
# HCP Vault Configuration Variables
# ---------------------------------------------------------------------------- #

variable "hcp_client_id" {
  description = "Client ID for HCP authentication."
  type        = string
}

variable "hcp_client_secret" {
  description = "Client secret for HCP authentication."
  type        = string
  sensitive   = true
}

variable "hcp_secret_app_name" {
  description = "Name of the HCP application used for storing secrets."
  type        = string
  default     = "tf-cloudflare"
}
