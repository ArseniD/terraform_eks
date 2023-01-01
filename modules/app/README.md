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
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.8.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.16.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.46.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.8.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.16.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_external_dns"></a> [iam\_assumable\_role\_external\_dns](#module\_iam\_assumable\_role\_external\_dns) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.9.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/4.46.0/docs/resources/iam_policy) | resource |
| [helm_release.cm](https://registry.terraform.io/providers/hashicorp/helm/2.8.0/docs/resources/release) | resource |
| [helm_release.external-dns](https://registry.terraform.io/providers/hashicorp/helm/2.8.0/docs/resources/release) | resource |
| [helm_release.monitoring](https://registry.terraform.io/providers/hashicorp/helm/2.8.0/docs/resources/release) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/2.8.0/docs/resources/release) | resource |
| [kubectl_manifest.cluster_issuer](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_deployment_v1.app](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/deployment_v1) | resource |
| [kubernetes_ingress_v1.app](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace_v1.app](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/namespace_v1) | resource |
| [kubernetes_service_v1.app](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/resources/service_v1) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/4.46.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/4.46.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/4.46.0/docs/data-sources/route53_zone) | data source |
| [kubernetes_service.nginx_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.16.1/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_image"></a> [app\_image](#input\_app\_image) | Application docker image. | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name. | `string` | n/a | yes |
| <a name="input_app_namespace"></a> [app\_namespace](#input\_app\_namespace) | Application namespace. | `string` | n/a | yes |
| <a name="input_cluster_issuer_secret"></a> [cluster\_issuer\_secret](#input\_cluster\_issuer\_secret) | Cluster issuer secret name. | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider. | `string` | n/a | yes |
| <a name="input_cm_namespace"></a> [cm\_namespace](#input\_cm\_namespace) | Cert-manager namespace. | `string` | n/a | yes |
| <a name="input_deployment_prefix"></a> [deployment\_prefix](#input\_deployment\_prefix) | Deployment prefix. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of the hosted zone. | `string` | n/a | yes |
| <a name="input_ic_namespace"></a> [ic\_namespace](#input\_ic\_namespace) | Ingress controller namespace. | `string` | n/a | yes |
| <a name="input_monitoring_namespace"></a> [monitoring\_namespace](#input\_monitoring\_namespace) | Monitoring namespace. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain for the root domain. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_link"></a> [app\_link](#output\_app\_link) | Application fully qualified domain name. |
| <a name="output_lb_address"></a> [lb\_address](#output\_lb\_address) | Load balancer address. |
<!-- END_TF_DOCS -->
