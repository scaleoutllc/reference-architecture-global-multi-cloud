resource "acme_certificate" "oci-us" {
  common_name               = "oci-us.${local.domain}"
  subject_alternative_names = ["*.oci-us.${local.domain}"]
  key_type                  = 4096
  account_key_pem           = tls_private_key.letsencrypt.private_key_pem
  min_days_remaining        = 60
  dns_challenge {
    provider = "route53"
  }
}
