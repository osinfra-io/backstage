# Local Values
# https://www.terraform.io/docs/language/values/locals.html

locals {
  global = data.terraform_remote_state.global.outputs
  workspace_environment = var.environment == "sb" ? "sandbox" : var.environment == "nonprod" ? "non-production" : var.environment == "prod" ? "production" : null
}
