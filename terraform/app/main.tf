data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "xxx-terraform-states-backend"
    key    = "eks/terraform.tfstate"
    region = "eu-west-1"
  }
}

module "app" {
  source = "../../modules/app"

  region    = "eu-west-1"
  app_name  = "app"
  app_image = "nginxdemos/hello"

  cluster_issuer_secret   = "letsencrypt-prod"
  cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url

  app_namespace        = "dev"
  cm_namespace         = "cm"
  ic_namespace         = "ingress-nginx"
  monitoring_namespace = "monitoring"

  domain_name = "arsenidudko.link"
  subdomain   = "xxxx"

  deployment_prefix = local.deployment_prefix
}
