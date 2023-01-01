resource "kubernetes_namespace_v1" "app" {
  metadata {
    annotations = {
      name = var.app_namespace
    }
    name = var.app_namespace
  }
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 2

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
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node.k8s/scope"
                  operator = "In"
                  values   = ["application"]
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace_v1.app,
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
    kubernetes_namespace_v1.app,
    kubectl_manifest.cluster_issuer
  ]

}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = var.app_namespace

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = var.cluster_issuer_secret
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
    kubernetes_namespace_v1.app,
    kubectl_manifest.cluster_issuer
  ]

}
