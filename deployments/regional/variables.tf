variable "backstage_replicas" {
  description = "The number of replicas for the Backstage deployment"
  type        = number
  default     = 1
}

variable "backstage_version" {
  description = "The version of the Backstage deployment"
  type        = string
}

variable "cloud_sql_host_project_id" {
  description = "Host project ID for the shared VPC"
  type        = string
}

variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP key"
  type        = string
  sensitive   = true
}
