data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "${helm_release.nginx_ingress.name}-${helm_release.nginx_ingress.chart}-controller"
    namespace = var.ic_namespace
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "controller"
  namespace  = var.ic_namespace
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.4.0"

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "defaultBackend.replicaCount"
    value = "2"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.serviceMonitor.additionalLabels.release"
    value = var.monitoring_namespace
  }

  depends_on = [
    time_sleep.wait_nginx_termination
  ]
}

# Helm chart destruction will return immediately, we need to wait until the pods are fully evicted
# https://github.com/hashicorp/terraform-provider-helm/issues/593
resource "time_sleep" "wait_nginx_termination" {
  destroy_duration = "100s"
}
