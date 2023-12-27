# Output Values
# https://www.terraform.io/language/values/outputs

output "backstage_iap_client_id" {
  description = "The IAP client ID for Backstage"
  value       = local.global.backstage_iap_client_id
}

output "backstage_iap_client_secret" {
  description = "The IAP client secret for Backstage"
  value       = local.global.backstage_iap_client_secret
  sensitive   = true
}

output "project_id" {
  description = "The project ID"
  value       = local.global.project_id
}

output "sql_instance" {
  description = "SQL instance name"
  value       = module.cloud_sql[0].sql_instance
}
