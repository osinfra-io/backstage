variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
}

variable "datadog_app_key" {
  description = "Datadog APP key"
  type        = string
}

variable "backstage_replicas" {
  description = "The number of replicas for the Backstage deployment"
  type        = number
  default     = 1
}

variable "backstage_version" {
  description = "The version of the Backstage deployment"
  type        = string
}
