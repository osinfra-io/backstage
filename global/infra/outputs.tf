# Output Values
# https://www.terraform.io/language/values/outputs

output "backstage_iap_client_id" {
  description = "The IAP client ID for Backstage"
  value       = google_iap_client.backstage.client_id
}

output "backstage_iap_client_secret" {
  description = "The IAP client secret for Backstage"
  value       = google_iap_client.backstage.secret
  sensitive   = true
}

output "project_number" {
  description = "The project number"
  value       = module.project.project_number
}

output "project_id" {
  description = "The project ID"
  value       = module.project.project_id
}
