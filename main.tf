

resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "notreal"
  content  = "1.2.3.4"
  type    = "A"
  proxied = true
}
