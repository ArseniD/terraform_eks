resource "helm_release" "nginx_ingress" {
  name             = "controller"
  namespace        = var.ic_namespace
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.4.0"

  values = [
    templatefile(
      "${path.module}/templates/nginx_ingress.tpl.yaml",
      {
        "replica_count" = 2
        "label"         = "node.k8s/scope"
        "label_value"   = "ingress"
      }
    )
  ]
  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    helm_release.monitoring
  ]
}
