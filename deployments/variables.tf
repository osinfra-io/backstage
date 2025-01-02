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

variable "datadog_enable" {
  description = "Enable Datadog integration"
  type        = bool
  default     = false
}

variable "k8s_workload_identity_service_account" {
  description = "The service account to use for the workload identity"
  type        = string
}

variable "project_billing_account" {
  description = "The alphanumeric ID of the billing account this project belongs to"
  type        = string
  default     = "01C550-A2C86B-B8F16B"
}

variable "project_cis_2_2_logging_sink_project_id" {
  description = "The CIS 2.2 logging sink benchmark project ID"
  type        = string
}

variable "project_folder_id" {
  description = "The numeric ID of the folder this project should be created under. Only one of `org_id` or `folder_id` may be specified"
  type        = string
}

variable "project_monthly_budget_amount" {
  description = "The monthly budget amount in USD to set for the project"
  type        = number
  default     = 5
}
