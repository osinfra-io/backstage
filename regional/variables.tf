# Input Variables
# https://www.terraform.io/language/values/variables

variable "enable_sql_instance" {
  description = "Enable the creation of the SQL instance"
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment suffix for example: `sb` (Sandbox), `nonprod` (Non-Production), `prod` (Production)"
  type        = string
  default     = "sb"
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance"
  type        = bool
  default     = true
}

variable "host_project_id" {
  description = "Host project ID for the shared VPC"
  type        = string
}

variable "machine_tier" {
  description = "The machine type to use. Postgres supports only shared-core machine types, and custom machine types such as db-custom-2-13312"
  type        = string
  default     = "db-f1-micro"
}

variable "region" {
  description = "The region in which the resource belongs"
  type        = string
}

variable "remote_bucket" {
  description = "The remote bucket the `terraform_remote_state` data source retrieves the root module output values from"
  type        = string
}
