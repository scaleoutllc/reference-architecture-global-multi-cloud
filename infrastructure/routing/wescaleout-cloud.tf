resource "cloudflare_zone" "wescaleout-cloud" {
  account_id = local.cloudflare_account_id
  zone       = "wescaleout.cloud"
}
