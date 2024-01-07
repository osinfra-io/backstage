# Local Values
# https://www.terraform.io/language/values/locals

locals {
  environment_map = {
    "sb"      = "sandbox"
    "nonprod" = "non-production"
    "prod"    = "production"
  }

  regional              = data.terraform_remote_state.regional.outputs
  workspace_environment = lookup(local.environment_map, var.environment, null)

}
