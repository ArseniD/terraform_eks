module "vpc" {
  source            = "../../modules/vpc/"
  vpc_cidr          = "10.10.0.0/16"
  deployment_prefix = local.deployment_prefix
}
