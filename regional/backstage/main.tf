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
    cluster_ca_certificate = base64decode(
      var.cluster_ca_certificate
    )

    host  = "https://${var.cluster_endpoint}"
    token = data.google_client_config.current.access_token
  }
}

# Kubernetes Provider
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest

provider "kubernetes" {
  cluster_ca_certificate = base64decode(
    var.cluster_ca_certificate
  )

  host  = "https://${var.cluster_endpoint}"
  token = data.google_client_config.current.access_token
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

  workspace = "${var.region}-${local.workspace_environment}"
}

# Google SQL User Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

resource "google_sql_user" "backstage" {
  project  = local.regional.project_id
  name     = "backstage"
  instance = local.regional.sql_instance
  password = random_password.backstage.result
}

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

  set {
    name  = "backstage.image.pullSecrets"
    value = kubernetes_secret_v1.github_container_registry_key.metadata.0.name
  }

  values = [
    file("${path.module}/helm/values.yaml")
  ]

  version = "1.8.1"
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

# Kubernetes Ingress Resource
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1

resource "kubernetes_ingress_v1" "backstage" {
  metadata {
    name      = "backstage"
    namespace = "backstage"

    annotations = {
      "kubernetes.io/ingress.allow-http"       = "false"
      "networking.gke.io/managed-certificates" = kubernetes_manifest.backstage_tls.manifest.metadata.name
    }
  }
  spec {
    rule {
      host = var.host

      http {
        path {
          backend {
            service {
              name = "http-backend"
              port {
                number = 7007
              }
            }
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
}

# Kubernetes Manifest Resource
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest

resource "kubernetes_manifest" "backstage_backend_config" {
  manifest = {
    "apiVersion" = "cloud.google.com/v1"
    "kind"       = "BackendConfig"
    "metadata" = {
      "name"      = "backstage-backend-config"
      "namespace" = "backstage"
    }
    "spec" = {
      "iap" = {
        "enabled" = true
        "oauthclientCredentials" = {
          "secretName" = kubernetes_secret_v1.iap.metadata.0.name
        }
      }
    }
  }
}

resource "kubernetes_manifest" "backstage_tls" {
  manifest = {
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "ManagedCertificate"
    "metadata" = {
      "name"      = "backstage-tls"
      "namespace" = "backstage"
    }
    "spec" = {
      "domains" = [
        "${var.host}",
      ]
    }
  }
}

# Kubernetes Secret Resource
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1

resource "kubernetes_secret_v1" "iap" {

  data = {
    client_id     = local.regional.backstage_iap_client_id
    client_secret = local.regional.backstage_iap_client_secret
  }

  metadata {
    name      = "iap"
    namespace = "backstage"
  }

}

resource "kubernetes_secret_v1" "github_container_registry_key" {
  metadata {
    name      = "github-container-registry-key"
    namespace = "backstage"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "ghcr.io" = {
          "auth" = var.github_container_registry_key
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret_v1" "postgres" {

  data = {
    POSTGRES_USER     = google_sql_user.backstage.name
    POSTGRES_PASSWORD = google_sql_user.backstage.password
  }

  metadata {
    name      = "postgres"
    namespace = "backstage"
  }

}

# # Kubernetes Service Resource
# # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1

# resource "kubernetes_service_v1" "backstage" {
#   metadata {
#     annotations = {
#       "cloud.google.com/backend-config" = jsonencode({ "default" : kubernetes_manifest.backstage_backend_config.manifest.metadata.name })
#     }
#     name      = "backstage"
#     namespace = "backstage"
#   }

#   spec {
#     port {
#       name        = "http"
#       protocol    = "TCP"
#       port        = kubernetes_deployment_v1.backstage.spec.0.template.0.spec.0.container.0.port.0.container_port
#       target_port = kubernetes_deployment_v1.backstage.spec.0.template.0.spec.0.container.0.port.0.container_port
#     }

#     selector = {
#       app = "backstage"
#     }

#     type = "NodePort"
#   }
# }

# Random Password Resource
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password

resource "random_password" "backstage" {
  length  = 16
  special = true
}
