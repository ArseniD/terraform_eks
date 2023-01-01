output "cluster_name" {
  value = module.eks.cluster_name
  description = "EKS cluster name."
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
  description = "The URL on the EKS cluster for the OpenID Connect identity provider."
}
