# Local Values
# https://www.terraform.io/docs/language/values/locals.html

locals {
  global = data.terraform_remote_state.global.outputs
}
