variable "aws_region" {
  type        = string
  description = "AWS region."
  default     = "eu-west-1"
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

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster."
}

variable "cluster_issuer_secret" {
  type        = string
  description = "Cluster issuer secret name."
}

variable "vpc_name" {
  type        = string
  description = "VPC name."
}

variable "vpc_cidr" {
  type        = string
  description = "The IPv4 CIDR block for the VPC."
}
