# Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_datadog"></a> [datadog](#module\_datadog) | github.com/osinfra-io/terraform-datadog-google-integration | v0.3.0 |
| <a name="module_helpers"></a> [helpers](#module\_helpers) | github.com/osinfra-io/terraform-core-helpers//root | v0.1.2 |
| <a name="module_project"></a> [project](#module\_project) | github.com/osinfra-io/terraform-google-project | v0.4.5 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API key | `string` | n/a | yes |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | Datadog APP key | `string` | n/a | yes |
| <a name="input_datadog_enable"></a> [datadog\_enable](#input\_datadog\_enable) | Enable Datadog integration | `bool` | `false` | no |
| <a name="input_project_billing_account"></a> [project\_billing\_account](#input\_project\_billing\_account) | The alphanumeric ID of the billing account this project belongs to | `string` | `"01C550-A2C86B-B8F16B"` | no |
| <a name="input_project_cis_2_2_logging_sink_project_id"></a> [project\_cis\_2\_2\_logging\_sink\_project\_id](#input\_project\_cis\_2\_2\_logging\_sink\_project\_id) | The CIS 2.2 logging sink benchmark project ID | `string` | n/a | yes |
| <a name="input_project_folder_id"></a> [project\_folder\_id](#input\_project\_folder\_id) | The numeric ID of the folder this project should be created under. Only one of `org_id` or `folder_id` may be specified | `string` | n/a | yes |
| <a name="input_project_monthly_budget_amount"></a> [project\_monthly\_budget\_amount](#input\_project\_monthly\_budget\_amount) | The monthly budget amount in USD to set for the project | `number` | `5` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
