# Required Providers
# https://www.terraform.io/docs/language/providers/requirements.html#requiring-providers

terraform {
  required_providers {

    datadog = {
      source = "datadog/datadog"
    }

    # Google Cloud Provider
    # https://www.terraform.io/docs/providers/google/index.html

    google = {
      source = "hashicorp/google"
    }
  }
}

# Datadog Provider
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
