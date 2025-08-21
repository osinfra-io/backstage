# Datadog Google Cloud Platform Integration Module (osinfra.io)
# https://github.com/osinfra-io/opentofu-datadog-google-integration

module "datadog" {
  source = "github.com/osinfra-io/opentofu-datadog-google-integration?ref=3e87e321842678ad478ba2c8d007a7685338e8d7" # v0.3.5
  count  = var.datadog_enable ? 1 : 0

  api_key                            = var.datadog_api_key
  is_cspm_enabled                    = true
  is_security_command_center_enabled = true
  labels                             = module.helpers.labels
  project                            = module.project.id
}

# Google Project Module (osinfra.io)
# https://github.com/osinfra-io/opentofu-google-project

module "project" {
  source = "github.com/osinfra-io/opentofu-google-project?ref=655916e58848e16af406e4968b25bb77fb0f1119" # v0.4.5

  billing_account                 = var.project_billing_account
  cis_2_2_logging_sink_project_id = var.project_cis_2_2_logging_sink_project_id
  description                     = "backstage"
  folder_id                       = var.project_folder_id
  labels                          = module.helpers.labels
  monthly_budget_amount           = var.project_monthly_budget_amount
  prefix                          = "plt"

  services = [
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}

# Project IAM Member Resource
# https://search.opentofu.org/provider/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member

resource "google_project_iam_member" "cloud_sql_proxy" {
  member  = "serviceAccount:${var.k8s_workload_identity_service_account}"
  project = module.project.id
  role    = "roles/cloudsql.client"
}
