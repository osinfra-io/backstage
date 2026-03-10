# OpenTofu Core Helpers Module (osinfra.io)
# https://github.com/osinfra-io/pt-arche-core-helpers

module "helpers" {
  source = "github.com/osinfra-io/pt-arche-core-helpers//root?ref=9734175404f3c0b26b0a58a6c877828dba2dea70" # v0.2.1

  cost_center         = "x001"
  data_classification = "public"
  repository          = "backstage"
  team                = "platform-backstage"
}
