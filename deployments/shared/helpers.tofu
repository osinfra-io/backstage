# OpenTofu Core Helpers Module (osinfra.io)
# https://github.com/osinfra-io/opentofu-core-helpers

module "helpers" {
  source = "github.com/osinfra-io/opentofu-core-helpers//root?ref=v0.1.2"

  cost_center         = "x001"
  data_classification = "public"
  repository          = "backstage"
  team                = "platform-backstage"
}
