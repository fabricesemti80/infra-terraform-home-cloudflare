

variable "api_token" {
  default = ""
  type    = string
}

variable "zone_id" {
  default = ""
  type    = string
}

variable "account_id" {
  default = ""
  type    = string
}

variable "domain" {
  default = ""
  type    = string
}

variable "tunnel_id_docker" {
  default = ""
  type    = string

}
variable "tunnel_secret_docker" {
  default = ""
  type    = string
  sensitive = true

}

