terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.46.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  depends_on = [
    module.vpc
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
  depends_on = [
    module.vpc
  ]
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  token                  = local.cluster_token
  cluster_ca_certificate = local.cluster_ca_certificate
}
#
provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint
    token                  = local.cluster_token
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}
#
provider "kubectl" {
  host                   = local.cluster_endpoint
  token                  = local.cluster_token
  cluster_ca_certificate = local.cluster_ca_certificate
}
