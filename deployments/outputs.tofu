# Output Values
# https://opentofu.org/docs/language/values/outputs

output "backstage_iap_client_id" {
  value = google_iap_client.this.client_id
}

output "backstage_iap_client_secret" {
  value     = google_iap_client.this.secret
  sensitive = true
}
