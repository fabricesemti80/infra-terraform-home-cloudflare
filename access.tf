# ---------------------------------------------------------------------------- #
# Zero Trust Access Configurations
# ---------------------------------------------------------------------------- #

# Access policy that bypasses authentication for all users
# This allows unrestricted access to the specified applications
resource "cloudflare_zero_trust_access_policy" "example_zero_trust_access_policy" {
  account_id       = var.cf_account_id
  decision         = "bypass"
  include          = [{ everyone = {} }]
  name             = "Application Bypass TF"
  session_duration = "30m"
}

# Zero Trust applications for self-hosted services
# These applications require authentication unless bypassed by the policy above
resource "cloudflare_zero_trust_access_application" "applications" {
  for_each          = local.zero_trust_applications
  zone_id           = var.cf_zone_id
  name              = each.value.name
  domain            = each.value.domain
  type              = each.value.type
  session_duration  = each.value.session_duration
  skip_interstitial = each.value.skip_interstitial

  policies = [{
    id = cloudflare_zero_trust_access_policy.example_zero_trust_access_policy.id
  }]
}
