# Required Providers
# https://opentofu.org/docs/language/providers/requirements/

terraform {
  # State and Plan Encryption
  # https://opentofu.org/docs/language/state/encryption

  # The commented out sections below demonstrate how to configure
  # fallback encryption methods for state and plan files for bootstrapping.

  encryption {
    # method "unencrypted" "migrate" {}

    key_provider "gcp_kms" "default" {
      kms_encryption_key = var.state_kms_encryption_key
      key_length         = 32
    }

    method "aes_gcm" "default" {
      keys = key_provider.gcp_kms.default
    }

    plan {
      method   = method.aes_gcm.default
      enforced = true

      # fallback {
      #   method = method.unencrypted.migrate
      # }
    }

    state {
      method   = method.aes_gcm.default
      enforced = true

      # fallback {
      #   method = method.unencrypted.migrate
      # }
    }
  }

  required_providers {

    datadog = {
      source = "datadog/datadog"
    }

    # Google Cloud Platform Provider
    # https://search.opentofu.org/provider/hashicorp/google/latest/docs

    google = {
      source = "hashicorp/google"
    }
  }
}

# Datadog Provider
# https://search.opentofu.org/provider/opentofu/datadog/latest

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
