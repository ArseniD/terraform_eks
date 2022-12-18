resource "helm_release" "monitoring" {
  name       = "monitoring"
  namespace  = var.monitoring_namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "42.2.1"

  values = [
    templatefile(
      "${path.module}/templates/values.tpl.yaml",
      {
        "fqdn"   = local.fqdn,
        "secret" = var.cluster_issuer_secret
      }
    )
  ]
}
