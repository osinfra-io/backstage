variable "backstage_replicas" {
  description = "The number of replicas for the Backstage deployment"
  type        = number
  default     = 1
}

variable "backstage_resources_limits_cpu" {
  description = "The CPU limit for the audit container"
  type        = string
  default     = "40m"
}

variable "backstage_resources_limits_memory" {
  description = "The memory limit for the audit container"
  type        = string
  default     = "128Mi"
}

variable "backstage_resources_requests_cpu" {
  description = "The CPU request for the audit container"
  type        = string
  default     = "10m"
}

variable "backstage_resources_requests_memory" {
  description = "The memory request for the audit container"
  type        = string
  default     = "32Mi"
}

variable "backstage_version" {
  description = "The version of the Backstage deployment"
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

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
  default     = "1102240"
}

variable "github_app_client_id" {
  description = "GitHub App Client ID"
  type        = string
  default     = "Iv23liBR7fZfikt1WnLb"
}

variable "github_app_client_secret" {
  description = "GitHub App Client Secret"
  type        = string
  sensitive   = true
}

variable "github_app_private_key" {
  description = "GitHub App Private Key"
  type        = string
  sensitive   = true
}

variable "github_app_webhook_secret" {
  description = "GitHub App Webhook Secret"
  type        = string
  sensitive   = true
}


variable "networking_project_id" {
  description = "The project ID for the shared VPC"
  type        = string
}

variable "remote_bucket" {
  description = "The remote bucket the `terraform_remote_state` data source retrieves the state from"
  type        = string
}
