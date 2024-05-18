terraform {

  # Requiring Providers
  # https://www.terraform.io/language/providers/requirements#requiring-providers

  required_providers {

    # Datadog Provider
    # https://registry.terraform.io/providers/DataDog/datadog/latest/docs

    datadog = {
      source = "datadog/datadog"
    }

    # Google Cloud Platform Provider
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs

    google = {
      source = "hashicorp/google"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

# Datadog Google Cloud Platform Integration Module (osinfra.io)
# https://github.com/osinfra-io/terraform-datadog-google-integration

# module "datadog" {
#   source = "github.com/osinfra-io/terraform-datadog-google-integration//global?ref=v0.1.0"

#   api_key         = var.datadog_api_key
#   is_cspm_enabled = true
#   project         = module.project.project_id
# }

# Google Project Module (osinfra.io)
# https://github.com/osinfra-io/terraform-google-project

module "project" {
  source = "github.com/osinfra-io/terraform-google-project//global?ref=v0.2.1"

  cis_2_2_logging_sink_project_id = var.cis_2_2_logging_sink_project_id
  description                     = "backstage"
  environment                     = var.environment
  folder_id                       = var.folder_id

  labels = {
    cost-center = "x001"
    env         = var.environment
    repository  = "backstage"
    platform    = "backstage"
    team        = "platform-backstage"
  }

  prefix = "plt"

  services = [
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

# IAP Client Brand Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_brand

# Brands can only be created once for a Google Cloud project and the underlying Google API doesn't not support DELETE or PATCH methods.
# Destroying a Terraform-managed Brand will remove it from state but will not delete it from Google Cloud.
# If you need to delete the Brand, you must do so manually in the Google Cloud Console.

resource "google_iap_brand" "this" {
  application_title = "Backstage (Cloud IAP Protected)"
  project           = module.project.project_id

  # This email address can either be a user's address or a Google Groups alias. While service accounts also have an email address,
  # they are not actual valid email addresses, and cannot be used when creating a brand. However, a service account can be the owner
  # of a Google Group. Either create a new Google Group or configure an existing group and set the desired service account as an
  # owner of the group

  support_email = "backstage@osinfra.io"
}

# IAP Client Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_client

resource "google_iap_client" "backstage" {
  brand        = google_iap_brand.this.name
  display_name = "Backstage"
}

# IAP Web IAM Binding Resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam

resource "google_iap_web_iam_binding" "backstage" {

  members = [
    "group:backstage@osinfra.io",
  ]

  project = module.project.project_id

  # Authoritative for a given role.

  role = "roles/iap.httpsResourceAccessor"
}
