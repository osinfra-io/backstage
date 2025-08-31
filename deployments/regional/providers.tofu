# Required Providers
# https://opentofu.org/docs/language/providers/requirements/

terraform {
  # State and Plan Encryption
  # https://opentofu.org/docs/language/state/encryption

  # The commented out sections below demonstrate how to configure
  # fallback encryption methods for state and plan files for bootstrapping.

  encryption {
    method "unencrypted" "migrate" {}

    key_provider "gcp_kms" "default" {
      kms_encryption_key = var.state_kms_encryption_key
      key_length         = 32
    }

    method "aes_gcm" "default" {
      keys = key_provider.gcp_kms.default
    }

    plan {
      method = method.aes_gcm.default
      # enforced = true

      fallback {
        method = method.unencrypted.migrate
      }
    }

    state {
      method = method.aes_gcm.default
      # enforced = true

      fallback {
        method = method.unencrypted.migrate
      }
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

    helm = {
      source = "hashicorp/helm"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Datadog Provider
# https://search.opentofu.org/provider/opentofu/datadog/latest

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# # Helm Provider
# # https://search.opentofu.org/provider/hashicorp/helm/latest

provider "helm" {
  kubernetes = {

    cluster_ca_certificate = base64decode(
      data.google_container_cluster.this.master_auth.0.cluster_ca_certificate
    )

    host  = data.google_container_cluster.this.endpoint
    token = data.google_client_config.this.access_token
  }
}

# # Kubernetes Provider
# # https://search.opentofu.org/provider/hashicorp/kubernetes/latest

provider "kubernetes" {
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.this.master_auth.0.cluster_ca_certificate
  )
  host  = "https://${data.google_container_cluster.this.endpoint}"
  token = data.google_client_config.this.access_token
}

# # Google Client Config Data Source
# # https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/client_config

data "google_client_config" "this" {
}

# # Google Container Cluster Data Source
# # https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/container_cluster

data "google_container_cluster" "this" {
  name     = "plt-${module.helpers.region}-${module.helpers.zone}"
  location = module.helpers.region
  project  = data.google_project.k8s.project_id
}

# Google Projects Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/projects

data "google_projects" "backstage" {
  filter = "name:plt-backstage-* labels.env:${module.helpers.environment}"
}

data "google_projects" "k8s" {
  filter = "name:plt-k8s-* labels.env:${module.helpers.environment}"
}

# Google Project Data Source
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/data-sources/project

data "google_project" "backstage" {
  project_id = data.google_projects.backstage.projects.0.project_id
}

data "google_project" "k8s" {
  project_id = data.google_projects.k8s.projects.0.project_id
}
