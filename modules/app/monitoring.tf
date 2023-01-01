resource "helm_release" "monitoring" {
  name             = "monitoring"
  namespace        = var.monitoring_namespace
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "42.2.1"

  values = [
    templatefile(
      "${path.module}/templates/kube_prometheus.tpl.yaml",
      {
        "fqdn"        = local.fqdn,
        "secret"      = var.cluster_issuer_secret
        "label"       = "node.k8s/scope"
        "label_value" = "monitoring"

      }
    )
  ]

  depends_on = [
    kubectl_manifest.cluster_issuer
  ]
}
