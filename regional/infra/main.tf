# Required Providers
# https://www.terraform.io/docs/language/providers/requirements.html#requiring-providers

terraform {
  required_providers {

    # Google Cloud Provider
    # https://www.terraform.io/docs/providers/google/index.html

    google = {
      source = "hashicorp/google"
    }
  }
}

# Terraform Remote State Datasource
# https://www.terraform.io/docs/language/state/remote-state-data.html

data "terraform_remote_state" "global" {
  backend = "gcs"

  config = {
    bucket = var.remote_bucket
    prefix = "backstage"
  }

  workspace = "global-${local.workspace_environment}"
}

# Google Cloud SQL Module (osinfra.io)
# https://github.com/osinfra-io/terraform-google-cloud-sql

module "cloud_sql_instance" {
  source = "github.com/osinfra-io/terraform-google-cloud-sql//regional?ref=v0.1.4"

  count = var.enable_sql_instance ? 1 : 0


  availability_type = "REGIONAL"
  cost_center       = "x001"

  # These flags are required for CIS GCP v1.3.0 compliance

  database_flags = [
    {
      name  = "cloudsql.enable_pgaudit"
      value = "on"
    },
    {
      name  = "log_checkpoints"
      value = "on"
    },
    {
      name  = "log_connections"
      value = "on"
    },
    {
      name  = "log_disconnections"
      value = "on"
    },
    {
      name  = "log_hostname"
      value = "on"
    },
    {
      name  = "log_lock_waits"
      value = "on"
    },
    {
      name  = "log_min_duration_statement"
      value = "-1"
    },
    {
      name  = "log_min_messages"
      value = "error"
    },
    {
      name  = "log_statement"
      value = "ddl"
    }
  ]

  deletion_protection = var.deletion_protection
  host_project_id     = var.host_project_id
  instance_name       = "backstage"

  labels = {
    env        = var.environment
    repository = "backstage"
    platform   = "backstage"
    team       = "platform-backstage"
  }

  machine_tier                   = var.machine_tier
  network                        = "standard-shared"
  point_in_time_recovery_enabled = true
  project_id                     = local.global.project_id
  region                         = var.region
}


# SQL Database Resource
# https://www.terraform.io/docs/providers/google/r/sql_database.html

resource "google_sql_database" "this" {

  count = var.enable_sql_instance ? 1 : 0

  instance = module.cloud_sql_instance[0].sql_instance
  name     = "backstage"
  project  = local.global.project_id
}
