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
  project                        = data.google_project.this.project_id
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
