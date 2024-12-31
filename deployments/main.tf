# Datadog Google Cloud Platform Integration Module (osinfra.io)
# https://github.com/osinfra-io/terraform-datadog-google-integration

module "datadog" {
  source = "github.com/osinfra-io/terraform-datadog-google-integration?ref=v0.3.0"
  count  = var.datadog_enable ? 1 : 0

  api_key                            = var.datadog_api_key
  is_cspm_enabled                    = true
  is_security_command_center_enabled = true
  labels                             = module.helpers.labels
  project                            = module.project.id
}

# Google Project Module (osinfra.io)
# https://github.com/osinfra-io/terraform-google-project

module "project" {
  source = "github.com/osinfra-io/terraform-google-project?ref=v0.4.5"

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
    "iap.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}

# IAP Client Brand Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_brand

# Brands can only be created once for a Google Cloud project and the underlying Google API doesn't not support DELETE or PATCH methods.
# Destroying a Terraform-managed Brand will remove it from state but will not delete it from Google Cloud.
# If you need to delete the Brand, you must do so manually in the Google Cloud Console.

resource "google_iap_brand" "this" {
  application_title = "Backstage"
  project           = module.project.id

  # This email address can either be a user's address or a Google Groups alias. While service accounts also have an email address,
  # they are not actual valid email addresses, and cannot be used when creating a brand. However, a service account can be the owner
  # of a Google Group.

  support_email = "gcp-iap@idexx.com"
}

# IAP Client Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_client

resource "google_iap_client" "this" {
  brand        = google_iap_brand.this.name
  display_name = "Backstage"
}

# IAP Web IAM Binding Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam

resource "google_iap_web_iam_binding" "this" {

  members = [
    "domain:osinfra.io"
  ]

  project = module.project.id

  # Authoritative for a given role.

  role = "roles/iap.httpsResourceAccessor"
}
