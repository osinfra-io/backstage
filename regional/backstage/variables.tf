# Input Variables
# https://www.terraform.io/language/values/variables

variable "backstage_image_tag" {
  description = "The image tag for Backstage"
  type        = string
  default     = "test"
}

variable "cluster_ca_certificate" {
  description = "The cluster CA certificate"
  sensitive   = true
  type        = string
}

variable "cluster_endpoint" {
  description = "The cluster endpoint"
  type        = string
}

variable "environment" {
  description = "The environment suffix for example: `sb` (Sandbox), `nonprod` (Non-Production), `prod` (Production)"
  type        = string
  default     = "sb"
}

variable "github_container_registry_key" {
  description = "The GitHub key for container registry"
  type        = string
  sensitive   = true
}

variable "host" {
  description = "Host name"
}

variable "region" {
  description = "The region in which the resource belongs"
  type        = string
}

variable "remote_bucket" {
  description = "The remote bucket the `terraform_remote_state` data source retrieves the root module output values from"
  type        = string
}
