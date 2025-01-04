# Terraform Remote State Datasource
# https://www.terraform.io/docs/language/state/remote-state-data.html

data "terraform_remote_state" "main" {
  backend = "gcs"

  config = {
    bucket = var.remote_bucket
    prefix = module.helpers.repository
  }

  workspace = "main-${module.helpers.environment}"
}

# Google Cloud SQL Module (osinfra.io)
# https://github.com/osinfra-io/terraform-google-cloud-sql

module "cloud_sql" {
  source = "github.com/osinfra-io/terraform-google-cloud-sql//regional?ref=v0.2.1"

  deletion_protection            = false
  host_project_id                = var.networking_project_id
  instance_name                  = "backstage"
  labels                         = module.helpers.labels
  network                        = "standard-shared"
  point_in_time_recovery_enabled = false
  project                        = data.google_project.backstage.project_id
  region                         = module.helpers.region
}

# Datadog Synthetics Test Resource
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test

resource "datadog_synthetics_test" "this" {
  for_each = local.datadog_synthetic_tests

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = 1000
  }

  locations = each.value.locations
  message   = each.value.message
  name      = "${each.value.name} ${each.value.region} ${module.helpers.environment}"

  options_list {
    tick_every = 300

    retry {
      count    = 2
      interval = 120
    }

    monitor_priority = each.value.message_priority
  }

  request_definition {
    method = "GET"
    url    = each.value.url
  }

  request_headers = each.value.region == "global" ? {} : {
    Body = "services-${each.value.region}"
  }

  status  = each.value.status
  subtype = "http"

  tags = [
    "env:${module.helpers.environment}",
    "service:${each.value.service}",
    "region:${each.value.region}",
    "team:${module.helpers.team}"
  ]

  type = "api"
}

# DNS Record Set Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set

resource "google_dns_record_set" "backstage_a_record" {
  project      = var.networking_project_id
  name         = "${local.hostname}." # Trailing dot is required
  managed_zone = local.managed_zone
  type         = "A"
  ttl          = 300

  rrdatas = [kubernetes_ingress_v1.backstage.status.0.load_balancer.0.ingress.0.ip]
}

# Cloud SQL Database Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database

resource "google_sql_database" "this" {
  deletion_policy = "ABANDON"
  instance        = module.cloud_sql.instance
  name            = "backstage"
  project         = data.google_project.backstage.project_id
}

# Cloud SQL Database Users
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

resource "google_sql_user" "this" {
  deletion_policy = "ABANDON"
  instance        = module.cloud_sql.instance
  name            = "backstage"
  password        = random_password.this.result
  project         = data.google_project.backstage.project_id
}

# Helm Release
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release

resource "helm_release" "backstage" {
  chart      = "backstage"
  name       = "backstage"
  namespace  = "backstage"
  repository = "https://backstage.github.io/charts"

  dynamic "set" {
    for_each = local.helm_values
    content {
      name  = set.key
      value = set.value
    }
  }

  values = [
    file("${path.module}/helm/backstage.yml")
  ]

  version = "2.3.0"

  depends_on = [
    module.cloud_sql,
    kubernetes_secret.postgres
  ]
}

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
      host = local.hostname

      http {
        path {
          backend {
            service {
              name = "backstage"
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
      "name"      = "backstage-backend"
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
        local.hostname,
      ]
    }
  }
}

# Kubernetes Secret Resource
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret

resource "kubernetes_secret_v1" "github_app_credentials" {
  data = {
    GTIHUB_APP_ID             = var.github_app_id
    GITHUB_CLIENT_ID          = var.github_app_client_id
    GITHUB_APP_CLIENT_SECRET  = var.github_app_client_secret
    GITHUB_APP_PRIVATE_KEY    = base64decode(var.github_app_private_key)
    GITHUB_APP_WEBHOOK_SECRET = var.github_app_webhook_secret
  }

  metadata {
    name      = "github-app-credentials"
    namespace = "backstage"
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "iap" {

  data = {
    client_id     = local.main.backstage_iap_client_id
    client_secret = local.main.backstage_iap_client_secret
  }

  metadata {
    name      = "iap"
    namespace = "backstage"
  }

}

resource "kubernetes_secret" "postgres" {
  data = {
    "POSTGRES_USER"     = "backstage"
    "POSTGRES_PASSWORD" = random_password.this.result
  }

  metadata {
    name      = "postgres-secrets"
    namespace = "backstage"
  }

  type = "Opaque"
}

resource "random_password" "this" {
  length  = 12
  special = true
}
