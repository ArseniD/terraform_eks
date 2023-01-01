resource "helm_release" "cm" {
  name             = "cert-manager"
  namespace        = var.cm_namespace
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  version = "1.10.1"

  values = [
    templatefile(
      "${path.module}/templates/cert_manager.tpl.yaml",
      {
        "replica_count" = 2
        "namespace"     = var.cm_namespace
        "label"         = "node.k8s/scope"
        "label_value"   = "extra"
      }
    )
  ]

}

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = templatefile(
    "${path.module}/templates/letsencrypt_issuer.tpl.yaml",
    {
      "name"        = var.cluster_issuer_secret
      "namespace"   = var.cm_namespace
      "email"       = "example@gmail.com"
      "server"      = "https://acme-v02.api.letsencrypt.org/directory"
      "label"       = "node.k8s/scope"
      "label_value" = "extra"
    }
  )

  depends_on = [
    helm_release.cm
  ]
}
