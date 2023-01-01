variable "region" {
 type = string
 description = "AWS region"
}

variable "app_name" {
  type        = string
  description = "Application name."
}

variable "app_image" {
  type        = string
  description = "Application docker image."
}

variable "app_namespace" {
  type        = string
  description = "Application namespace."
}

variable "ic_namespace" {
  type        = string
  description = "Ingress controller namespace."
}

variable "cm_namespace" {
  type        = string
  description = "Cert-manager namespace."
}

variable "monitoring_namespace" {
  type        = string
  description = "Monitoring namespace."
}

variable "domain_name" {
  type        = string
  description = "Domain name of the hosted zone."
}

variable "subdomain" {
  type        = string
  description = "Subdomain for the root domain."
}

variable "cluster_issuer_secret" {
  type        = string
  description = "Cluster issuer secret name."
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "The URL on the EKS cluster for the OpenID Connect identity provider."
}

variable "deployment_prefix" {
  type        = string
  description = "Deployment prefix."
}
