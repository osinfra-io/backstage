# Google Cloud SQL Module (osinfra.io)
# https://github.com/osinfra-io/terraform-google-cloud-sql

module "cloud_sql" {
  source = "github.com/osinfra-io/terraform-google-cloud-sql//regional?ref=bump"

  deletion_protection            = false
  host_project_id                = var.cloud_sql_host_project_id
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

# Cloud SQL Database Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database

resource "google_sql_database" "this" {
  instance = module.cloud_sql.instance
  name     = "backstage"
  project  = data.google_project.backstage.project_id
}

# Cloud SQL Database Users
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

resource "google_sql_user" "this" {
  instance = module.cloud_sql.instance
  name     = "backstage"
  password = random_password.this.result
  project  = data.google_project.backstage.project_id
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

# Kubernetes Secret Resource
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret

resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "postgres-secrets"
    namespace = "backstage"
  }

  data = {
    "username" = "backstage"
    "password" = random_password.this.result
  }

  type = "Opaque"
}

resource "random_password" "this" {
  length  = 12
  special = true
}
