# Local Values
# https://www.terraform.io/docs/language/values/locals.html

locals {
  datadog_mci_synthetic_url          = module.helpers.environment == "production" ? "https://gcp.osinfra.io/${local.datadog_synthetic_service}/metadata/cluster-name" : "https://${module.helpers.env}.gcp.osinfra.io/${local.datadog_synthetic_service}/metadata/cluster-name"
  datadog_synthetic_message_critical = module.helpers.environment == "production" ? "@hangouts-Platform-CriticalHighPriority" : ""
  datadog_synthetic_message_medium   = module.helpers.environment == "production" ? "@hangouts-Platform-MediumLowInfoPriority" : ""
  datadog_synthetic_name             = "Backstage"
  datadog_synthetic_service          = "backstage"

  datadog_synthetic_tests = module.helpers.region == "us-east1" || module.helpers.zone == "b" ? {
    "us-east1" = {
      locations = [
        "aws:us-east-1",
        "aws:us-east-2",
        "aws:us-west-1",
        "aws:us-west-2"
      ]

      message          = local.datadog_synthetic_message_medium
      message_priority = "3"
      name             = "Istio Ingress ${local.datadog_synthetic_name}"
      region           = module.helpers.region
      service          = local.datadog_synthetic_service
      status           = "paused"
      url              = module.helpers.environment == "production" ? "https://backstage.gcp.osinfra.io" : "https://backstage.${module.helpers.env}.gcp.osinfra.io"
    }
  } : {}

  helm_values = {
    "backstage.args[1]"                                  = "app-config.${module.helpers.environment}.yaml"
    "backstage.extraContainers[0].args[2]"               = "${data.google_project.backstage.project_id}:${module.helpers.region}:${module.cloud_sql.instance}"
    "backstage.image.registry"                           = local.registry
    "backstage.image.tag"                                = var.backstage_version
    "backstage.podLabels.tags\\.datadoghq\\.com/env"     = module.helpers.environment
    "backstage.podLabels.tags\\.datadoghq\\.com/version" = var.backstage_version
    "backstage.replicas"                                 = var.backstage_replicas
    # "backstage.resources.limits.cpu"                     = var.backstage_resources_limits_cpu
    # "backstage.resources.limits.memory"                  = var.backstage_resources_limits_memory
    # "backstage.resources.requests.cpu"                   = var.backstage_resources_requests_cpu
    # "backstage.resources.requests.memory"                = var.backstage_resources_requests_memory
  }

  hostname           = module.helpers.environment == "production" ? "backstage-${module.helpers.region}.gcp.osinfra.io" : "backstage-${module.helpers.region}.${module.helpers.env}.gcp.osinfra.io"
  kubernetes_project = module.helpers.environment == "sandbox" ? "plt-k8s-tf39-sb" : module.helpers.environment == "production" ? "plt-k8s-tf10-prod" : "plt-k8s-tf33-nonprod"
  managed_zone       = module.helpers.environment == "production" ? "gcp-osinfra-io" : "${module.helpers.env}-gcp-osinfra-io"
  main               = data.terraform_remote_state.main.outputs
  registry           = module.helpers.environment == "sandbox" ? "us-docker.pkg.dev/plt-lz-services-tf7f-sb/plt-docker-virtual" : "us-docker.pkg.dev/plt-lz-services-tf79-prod/plt-docker-virtual"
}
