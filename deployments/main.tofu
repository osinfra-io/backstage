# Datadog Google Cloud Platform Integration Module (osinfra.io)
# https://github.com/osinfra-io/pt-arche-datadog-google-integration

module "datadog" {
  source = "github.com/osinfra-io/pt-arche-datadog-google-integration?ref=a0f6388bd28937e49871f3e717740cf6775507ca" # v0.4.1
  count  = var.datadog_enable ? 1 : 0

  api_key                            = var.datadog_api_key
  is_cspm_enabled                    = true
  is_security_command_center_enabled = true
  labels                             = module.helpers.labels
  project                            = module.project.id
}

# Google Project Module (osinfra.io)
# https://github.com/osinfra-io/pt-arche-google-project

module "project" {
  source = "github.com/osinfra-io/pt-arche-google-project?ref=d51e04061b1a0f73ea56252cdc58eed01fb17e8e" # v0.6.7

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
