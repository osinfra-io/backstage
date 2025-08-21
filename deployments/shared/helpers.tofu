# OpenTofu Core Helpers Module (osinfra.io)
# https://github.com/osinfra-io/opentofu-core-helpers

module "helpers" {
  source = "github.com/osinfra-io/opentofu-core-helpers//root?ref=30d987aa83c8dc51b35370021d88444ae76957ee" # v0.1.2

  cost_center         = "x001"
  data_classification = "public"
  repository          = "backstage"
  team                = "platform-backstage"
}
