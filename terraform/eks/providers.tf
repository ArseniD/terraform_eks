terraform {
  backend "s3" {
    bucket         = "xxx-terraform-states-backend"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "xxx-terraform-states-backend"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      "Environment"      = "Development",
      "Team"             = "DevOps",
      "DeployedBy"       = "Terraform",
      "OwnerEmail"       = "devops@example.com"
      "DeploymentPrefix" = local.deployment_prefix
    }
  }

}
