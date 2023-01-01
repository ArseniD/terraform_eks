terraform {
  source = "../../modules//app/"
}

include "root" {
  path   = find_in_parent_folders()
}

dependency "eks" {
  config_path                             = "../eks/"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    cluster_oidc_issuer_url = "oidc_fake_issuer_url"
  }
}

inputs = {
  app_name   = "app"
  app_image  = "nginxdemos/hello"

  cluster_issuer_secret   = "letsencrypt-prod"
  cluster_oidc_issuer_url = dependency.eks.outputs.cluster_oidc_issuer_url

  app_namespace        = "dev"
  cm_namespace         = "cm"
  ic_namespace         = "ingress-nginx"
  monitoring_namespace = "monitoring"

  domain_name = "arsenidudko.link"
  subdomain   = "xxxxx"
}
