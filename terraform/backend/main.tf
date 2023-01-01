terraform {
  backend "s3" {
    bucket         = "xxx-terraform-states-backend"
    key            = "backend/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "xxx-terraform-states-backend"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
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
      "DeploymentPrefix" = "dev-terraform"
    }
  }
}

module "backend" {
  source              = "../../modules/backend/"
  bucket_name      = "xxx-terraform-states-backend"
  dynamodb_table_name = "xxx-terraform-states-backend"
}
