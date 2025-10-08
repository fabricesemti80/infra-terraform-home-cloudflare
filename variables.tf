
# ============================================================================ #
#                     CLOUDFLARE CONFIGURATION VARIABLES                      #
# ============================================================================ #

variable "cf_account_id" {
  description = "The ID of the Cloudflare account."
  type        = string
}

variable "cf_docker_zone_id" {
  description = "The ID of the Cloudflare zone."
  type        = string
}

variable "cf_docker_domain" {
  description = "The base domain for Docker services managed by Cloudflare."
  type        = string
}

variable "cf_api_token" {
  description = "API token for authenticating with Cloudflare."
  type        = string
  sensitive   = true
}

# ============================================================================ #
#                      PRIMARY TUNNEL CONFIGURATION VARIABLES                 #
# ============================================================================ #

# Add primary tunnel-specific variables here when needed

# ============================================================================ #
#                     SECONDARY TUNNEL CONFIGURATION VARIABLES                #
# ============================================================================ #

variable "terraformed_secondary_tunnel_config" {
  description = "Configuration for the Terraformed secondary tunnel."
  type        = string
  default     = ""
}

variable "terraformed_secondary_tunnel_credential" {
  description = "Credential for the Terraformed secondary tunnel."
  type        = string
  default     = ""
}



# ============================================================================ #
#                           SHARED CONFIGURATION                              #
# ============================================================================ #

variable "config_dir" {
  description = "Directory for configuration files."
  type        = string
  default     = "config"
}
