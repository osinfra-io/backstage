# Required Providers
# https://www.terraform.io/docs/language/providers/requirements.html#requiring-providers

terraform {
  required_providers {

    # Google Cloud Provider
    # https://www.terraform.io/docs/providers/google/index.html

    google = {
      source = "hashicorp/google"
    }

    helm = {
      source = "hashicorp/helm"
    }

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

# Helm Provider
# https://registry.terraform.io/providers/hashicorp/helm/latest

provider "helm" {
  kubernetes {
    cluster_ca_certificate = var.cluster_ca_certificate
    host                   = "https://${var.cluster_endpoint}"
    token                  = data.google_client_config.current.access_token
  }
}

# Kubernetes Provider
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest

provider "kubernetes" {
  cluster_ca_certificate = var.cluster_ca_certificate
  host                   = "https://${var.cluster_endpoint}"
  token                  = data.google_client_config.current.access_token
}


# Google Client Config Data Source
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config

data "google_client_config" "current" {
}

# Remote State Data Source
# https://www.terraform.io/language/state/remote-state-data

data "terraform_remote_state" "regional" {
  backend = "gcs"

  config = {
    bucket = var.remote_bucket
    prefix = "backstage"
  }

  workspace = "${var.region}-b-${local.workspace_environment}"
}

# Google SQL User Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

# resource "google_sql_user" "backstage" {
#   project  = local.regional.project_id
#   name     = "backstage"
#   instance = local.regional.sql_instance
#   password = random_password.backstage.result
# }

# Helm Release
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release

resource "helm_release" "backstage" {
  chart      = "backstage"
  name       = "backstage"
  namespace  = "backstage"
  repository = "https://backstage.github.io/charts"

  set {
    name  = "backstage.image.tag"
    value = var.backstage_image_tag
  }

  values = [
    file("${path.module}/helm/values.yaml")
  ]

  version = "1.9.3"
}

# # Kubernetes Deployment Resource
# # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1

# resource "kubernetes_deployment_v1" "backstage" {
#   metadata {
#     name      = "backstage"
#     namespace = "backstage"
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "backstage"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "backstage"
#         }
#       }
#       spec {
#         # service_account_name = "backstage"

#         image_pull_secrets {
#           name = kubernetes_secret_v1.github_container_registry_key.metadata.0.name
#         }

#         container {
#           name  = "backstage"
#           image = "ghcr.io/osinfra-io/backstage:test"

#           port {
#             name           = "http"
#             container_port = 7007
#           }

#           env_from {
#             secret_ref {
#               name = kubernetes_secret_v1.postgres.metadata.0.name
#             }
#           }

#           liveness_probe {
#             http_get {

#               # Health Check
#               # https://backstage.io/docs/plugins/observability#health-checks

#               path = "/healthcheck"
#               port = "7007"
#             }

#             initial_delay_seconds = 600
#             timeout_seconds       = 5
#             period_seconds        = 10
#             failure_threshold     = 5
#           }

#           readiness_probe {
#             http_get {
#               path = "/healthcheck"
#               port = "7007"
#             }

#             initial_delay_seconds = 15
#             timeout_seconds       = 5
#             period_seconds        = 10
#             failure_threshold     = 5
#           }
#         }

#         # This is the sidecar container for the Google Cloud SQL Auth Proxy. To access a Cloud SQL instance from an application running in
#         # Google Kubernetes Engine, you can use either the Cloud SQL Auth proxy (with public or private IP), or connect directly using
#         # a private IP address.

#         # https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine

#         container {
#           name  = "cloud-sql-proxy"
#           image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.8.1"

#           args = [
#             "--private-ip",
#             "--structured-logs",
#             "--port=5432",
#             "${local.regional.project_id}:${var.region}:${local.regional.sql_instance}"
#           ]
#         }
#       }
#     }
#   }

#   timeouts {
#     create = "5m"
#   }

# }



# Kubernetes Secret Resource
# # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1

# resource "kubernetes_secret_v1" "iap" {

#   data = {
#     client_id     = local.regional.backstage_iap_client_id
#     client_secret = local.regional.backstage_iap_client_secret
#   }

#   metadata {
#     name      = "iap"
#     namespace = "backstage"
#   }
# }


# resource "kubernetes_secret_v1" "postgres" {

#   data = {
#     POSTGRES_USER     = google_sql_user.backstage.name
#     POSTGRES_PASSWORD = google_sql_user.backstage.password
#   }

#   metadata {
#     name      = "postgres"
#     namespace = "backstage"
#   }
# }
