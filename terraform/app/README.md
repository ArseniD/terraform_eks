# terraform_eks
Deploy EKS cluster with app and Prometheus monitoring stack via Terraform.

#### TODO:
* Add Argo/Flux CD support
* Intoduce multi-cluster monitoring (separate control plane for monitoring)
* Fix sequence of deployment/destroy to avoid double Terraform plan/destroy actions
* Convert app to the helm chart and update functionality to perform stress test from UI

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app"></a> [app](#module\_app) | ../../modules/app | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.eks](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_link"></a> [app\_link](#output\_app\_link) | Application fully qualified domain name. |
| <a name="output_lb_address"></a> [lb\_address](#output\_lb\_address) | Load balancer address. |
<!-- END_TF_DOCS -->
