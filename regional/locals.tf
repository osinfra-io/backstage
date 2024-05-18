# Local Values
# https://www.terraform.io/docs/language/values/locals.html

locals {
  environment_map = {
    "sb"      = "sandbox"
    "nonprod" = "non-production"
    "prod"    = "production"
  }

  global                = data.terraform_remote_state.global.outputs
  workspace_environment = lookup(local.environment_map, var.environment, null)
}
