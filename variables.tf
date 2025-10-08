
# ============================================================================ #
#                     CLOUDFLARE CONFIGURATION VARIABLES                      #
# ============================================================================ #

variable "cf_account_id" {
  description = "The ID of the Cloudflare account."
  type        = string
}

variable "cf_secondary_zone_id" {
  description = "The ID of the Cloudflare zone for the secondary tunnel (fabricesemti.dev)."
  type        = string
}

variable "cf_secondary_domain" {
  description = "The base domain for secondary tunnel services (fabricesemti.dev)."
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

variable "cf_primary_zone_id" {
  description = "The ID of the Cloudflare zone for the primary tunnel (fs-tech.uk)."
  type        = string
}

variable "cf_primary_domain" {
  description = "The base domain for primary tunnel services (fs-tech.uk)."
  type        = string
}

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
