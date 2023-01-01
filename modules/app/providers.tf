terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
  }
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  token                  = local.cluster_auth_token
  cluster_ca_certificate = local.cluster_cert

}

provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint
    token                  = local.cluster_auth_token
    cluster_ca_certificate = local.cluster_cert
  }
}
#
provider "kubectl" {
  host                   = local.cluster_endpoint
  token                  = local.cluster_auth_token
  cluster_ca_certificate = local.cluster_cert
}
