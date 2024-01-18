# Regional Infrastructure Terraform Documentation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.12.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_sql"></a> [cloud\_sql](#module\_cloud\_sql) | github.com/osinfra-io/terraform-google-cloud-sql//regional | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [google_sql_database.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [terraform_remote_state.global](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether or not to allow Terraform to destroy the instance | `bool` | `true` | no |
| <a name="input_enable_sql_instance"></a> [enable\_sql\_instance](#input\_enable\_sql\_instance) | Enable the creation of the SQL instance | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment suffix for example: `sb` (Sandbox), `nonprod` (Non-Production), `prod` (Production) | `string` | `"sb"` | no |
| <a name="input_host_project_id"></a> [host\_project\_id](#input\_host\_project\_id) | Host project ID for the shared VPC | `string` | n/a | yes |
| <a name="input_machine_tier"></a> [machine\_tier](#input\_machine\_tier) | The machine type to use. Postgres supports only shared-core machine types, and custom machine types such as db-custom-2-13312 | `string` | `"db-f1-micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the resource belongs | `string` | n/a | yes |
| <a name="input_remote_bucket"></a> [remote\_bucket](#input\_remote\_bucket) | The remote bucket the `terraform_remote_state` data source retrieves the root module output values from | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backstage_iap_client_id"></a> [backstage\_iap\_client\_id](#output\_backstage\_iap\_client\_id) | The IAP client ID for Backstage |
| <a name="output_backstage_iap_client_secret"></a> [backstage\_iap\_client\_secret](#output\_backstage\_iap\_client\_secret) | The IAP client secret for Backstage |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The project ID |
| <a name="output_sql_instance"></a> [sql\_instance](#output\_sql\_instance) | SQL instance name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
