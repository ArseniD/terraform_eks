data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "xxx-terraform-states-backend"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "eks" {
  source            = "../../modules/eks"
  cluster_version   = "1.24"
  deployment_prefix = local.deployment_prefix
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets   = data.terraform_remote_state.vpc.outputs.private_subnets
  intra_subnets     = data.terraform_remote_state.vpc.outputs.intra_subnets
}
