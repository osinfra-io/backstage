# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  datadog_mci_synthetic_url          = module.helpers.environment == "production" ? "https://backstage.gcp.osinfra.io/health" : "https://backstage.${module.helpers.env}.gcp.osinfra.io/health"
  datadog_synthetic_message_critical = module.helpers.environment == "production" ? "@hangouts-Platform-CriticalHighPriority" : ""
  datadog_synthetic_message_medium   = module.helpers.environment == "production" ? "@hangouts-Platform-MediumLowInfoPriority" : ""
  datadog_synthetic_name             = "Backstage"
  datadog_synthetic_service          = "backstage"

  datadog_synthetic_tests = {
    "us-east1" = {
      locations = [
        "aws:us-east-1",
        "aws:us-east-2",
        "aws:us-west-1",
        "aws:us-west-2"
      ]

      message          = local.datadog_synthetic_message_medium
      message_priority = "3"
      name             = "Ingress ${local.datadog_synthetic_name}"
      region           = module.helpers.region
      service          = local.datadog_synthetic_service
      status           = "paused"
      url              = module.helpers.environment == "production" ? "https://backstage.gcp.osinfra.io" : "https://backstage.${module.helpers.env}.gcp.osinfra.io"
    }
  }

  registry           = module.helpers.environment == "sandbox" ? "us-docker.pkg.dev/plt-lz-services-tf7f-sb/plt-docker-virtual" : "us-docker.pkg.dev/plt-lz-services-tf79-prod/plt-docker-virtual"
  kubernetes_project = module.helpers.environment == "sandbox" ? "plt-k8s-tf39-sb" : module.helpers.environment == "production" ? "plt-k8s-tf10-prod" : "plt-k8s-tf33-nonprod"
}
