locals {
  azs                    = slice(data.aws_availability_zones.available.names, 0, 3)
  fqdn                   = "${var.subdomain}.${data.aws_route53_zone.selected.name}"
  lb_address             = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
  cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
  cluster_token          = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

  tags = {
    Terraform = "true"
  }
}
