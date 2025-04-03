# Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_datadog"></a> [datadog](#module\_datadog) | github.com/osinfra-io/terraform-datadog-google-integration | v0.3.5 |
| <a name="module_helpers"></a> [helpers](#module\_helpers) | github.com/osinfra-io/terraform-core-helpers//root | v0.1.2 |
| <a name="module_project"></a> [project](#module\_project) | github.com/osinfra-io/terraform-google-project | v0.4.5 |

## Resources

| Name | Type |
|------|------|
| [google_iap_brand.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_brand) | resource |
| [google_iap_client.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_client) | resource |
| [google_project_iam_member.cloud_sql_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key | `string` | n/a | yes |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | Datadog APP key | `string` | n/a | yes |
| <a name="input_datadog_enable"></a> [datadog\_enable](#input\_datadog\_enable) | Enable Datadog integration | `bool` | `false` | no |
| <a name="input_k8s_workload_identity_service_account"></a> [k8s\_workload\_identity\_service\_account](#input\_k8s\_workload\_identity\_service\_account) | The service account to use for the workload identity | `string` | n/a | yes |
| <a name="input_project_billing_account"></a> [project\_billing\_account](#input\_project\_billing\_account) | The alphanumeric ID of the billing account this project belongs to | `string` | `"01C550-A2C86B-B8F16B"` | no |
| <a name="input_project_cis_2_2_logging_sink_project_id"></a> [project\_cis\_2\_2\_logging\_sink\_project\_id](#input\_project\_cis\_2\_2\_logging\_sink\_project\_id) | The CIS 2.2 logging sink benchmark project ID | `string` | n/a | yes |
| <a name="input_project_folder_id"></a> [project\_folder\_id](#input\_project\_folder\_id) | The numeric ID of the folder this project should be created under. Only one of `org_id` or `folder_id` may be specified | `string` | n/a | yes |
| <a name="input_project_monthly_budget_amount"></a> [project\_monthly\_budget\_amount](#input\_project\_monthly\_budget\_amount) | The monthly budget amount in USD to set for the project | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backstage_iap_client_id"></a> [backstage\_iap\_client\_id](#output\_backstage\_iap\_client\_id) | n/a |
| <a name="output_backstage_iap_client_secret"></a> [backstage\_iap\_client\_secret](#output\_backstage\_iap\_client\_secret) | n/a |
<!-- END_TF_DOCS -->
