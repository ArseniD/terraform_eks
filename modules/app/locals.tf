data "aws_route53_zone" "selected" {
  name = var.domain_name
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "${helm_release.nginx_ingress.name}-${helm_release.nginx_ingress.chart}-controller"
    namespace = var.ic_namespace
  }

  depends_on = [
    helm_release.cm
  ]
}

locals {
  fqdn                                       = "${var.subdomain}.${data.aws_route53_zone.selected.name}"
  lb_address                                 = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
  k8s_service_account_external_dns_namespace = "kube-system"
  k8s_service_account_external_dns_name      = "external-dns"
  cluster_name                               = "${var.deployment_prefix}-eks-cluster"
  cluster_endpoint                           = data.aws_eks_cluster.this.endpoint
  cluster_auth_token                         = data.aws_eks_cluster_auth.this.token
  cluster_cert                               = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

}
