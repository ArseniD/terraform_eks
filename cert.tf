resource "helm_release" "cm" {
  name      = "cert-manager"
  namespace = var.cm_namespace

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  version = "1.10.1"

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    module.eks
  ]

}

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = templatefile(
    "${path.module}/templates/letsencrypt_issuer.tpl.yaml",
    {
      "name"      = var.cluster_issuer_secret
      "namespace" = var.cm_namespace
      "email"     = "example@gmail.com"
      "server"    = "https://acme-v02.api.letsencrypt.org/directory"
    }
  )

  depends_on = [
    helm_release.cm
  ]
}
