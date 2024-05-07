resource "tls_private_key" "letsencrypt" {
  algorithm = "RSA"
}

resource "acme_registration" "main" {
  account_key_pem = tls_private_key.letsencrypt.private_key_pem
  email_address   = "info@wescaleout.com"
}
