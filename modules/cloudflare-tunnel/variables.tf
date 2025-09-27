variable "cf_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "tunnel_name" {
  description = "Name of the Cloudflare Tunnel"
  type        = string
}

variable "config_dir" {
  description = "Directory for config files"
  type        = string
  default     = "config"
}

variable "ingress_rules" {
  description = "List of ingress rules for the tunnel"
  type = list(object({
    hostname = optional(string)
    service  = string
  }))
  default = []
}
