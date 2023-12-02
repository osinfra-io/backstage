# Required Providers
# https://www.terraform.io/docs/language/providers/requirements.html#requiring-providers

terraform {
  required_providers {

    # Google Cloud Provider
    # https://www.terraform.io/docs/providers/google/index.html

    google = {
      source = "hashicorp/google"
    }

    # Kubernetes Provider
    # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    # Random Provider
    # https://www.terraform.io/docs/providers/random/index.html
    random = {
      source = "hashicorp/random"
    }
  }
}

# Kubernetes Provider
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest

provider "kubernetes" {
  cluster_ca_certificate = base64decode(
    local.regional_infra.cluster_ca_certificate
  )
  host  = "https://${local.regional_infra.cluster_endpoint}"
  token = data.google_client_config.current.access_token
}

# Google Client Config Data Source
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
data "google_client_config" "current" {
}

# Remote State Data Source
# https://www.terraform.io/language/state/remote-state-data

data "terraform_remote_state" "regional" {
  backend   = "gcs"
  workspace = "${var.region}-infra-${var.environment}"

  config = {
    bucket = var.remote_bucket
    prefix = "backstage"
  }
}

# Google SQL User Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

# resource "google_sql_user" "backstage" {
#   project  = local.regional_infra.project_id
#   name     = "backstage"
#   instance = local.regional_infra.sql_instances["backstage"]
#   password = random_password.backstage.result
# }

resource "random_password" "backstage" {
  length  = 16
  special = true
}
