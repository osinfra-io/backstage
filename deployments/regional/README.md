# Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 3.50.0 |
| <a name="provider_google"></a> [google](#provider\_google) | 6.14.1 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_sql"></a> [cloud\_sql](#module\_cloud\_sql) | github.com/osinfra-io/terraform-google-cloud-sql//regional | bump |
| <a name="module_helpers"></a> [helpers](#module\_helpers) | github.com/osinfra-io/terraform-core-helpers//root | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [datadog_synthetics_test.this](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/synthetics_test) | resource |
| [google_sql_database.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_user.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [helm_release.backstage](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_client_config.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_container_cluster.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |
| [google_project.backstage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_project.k8s](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |
| [google_projects.backstage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/projects) | data source |
| [google_projects.k8s](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/projects) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backstage_extra_app_config_file"></a> [backstage\_extra\_app\_config\_file](#input\_backstage\_extra\_app\_config\_file) | Extra app config file for the Backstage deployment | `string` | n/a | yes |
| <a name="input_backstage_extra_app_config_ref"></a> [backstage\_extra\_app\_config\_ref](#input\_backstage\_extra\_app\_config\_ref) | Extra app config config map reference for the Backstage deployment | `string` | n/a | yes |
| <a name="input_backstage_replicas"></a> [backstage\_replicas](#input\_backstage\_replicas) | The number of replicas for the Backstage deployment | `number` | `1` | no |
| <a name="input_backstage_resources_limits_cpu"></a> [backstage\_resources\_limits\_cpu](#input\_backstage\_resources\_limits\_cpu) | The CPU limit for the audit container | `string` | `"40m"` | no |
| <a name="input_backstage_resources_limits_memory"></a> [backstage\_resources\_limits\_memory](#input\_backstage\_resources\_limits\_memory) | The memory limit for the audit container | `string` | `"128Mi"` | no |
| <a name="input_backstage_resources_requests_cpu"></a> [backstage\_resources\_requests\_cpu](#input\_backstage\_resources\_requests\_cpu) | The CPU request for the audit container | `string` | `"10m"` | no |
| <a name="input_backstage_resources_requests_memory"></a> [backstage\_resources\_requests\_memory](#input\_backstage\_resources\_requests\_memory) | The memory request for the audit container | `string` | `"32Mi"` | no |
| <a name="input_backstage_version"></a> [backstage\_version](#input\_backstage\_version) | The version of the Backstage deployment | `string` | n/a | yes |
| <a name="input_cloud_sql_host_project_id"></a> [cloud\_sql\_host\_project\_id](#input\_cloud\_sql\_host\_project\_id) | Host project ID for the shared VPC | `string` | n/a | yes |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key | `string` | n/a | yes |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | Datadog APP key | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
