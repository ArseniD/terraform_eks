resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          image = var.app_image
          name  = var.app_name

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer
  ]
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.app.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer
  ]

}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = var.app_namespace

    annotations = {
      "kubernetes.io/ingress.class"          = "nginx"
      "cert-manager.io/cluster-issuer"       = var.cluster_issuer_secret
      "nginx.ingress.kubernetes.io/app-root" = "/test"
    }
  }

  spec {
    rule {
      host = local.fqdn
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.app.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [local.fqdn]
      secret_name = "${var.app_name}-secret"
    }
  }

  depends_on = [
    kubectl_manifest.cluster_issuer
  ]

}
