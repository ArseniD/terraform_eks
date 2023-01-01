# IAM assumable role for external-dns
module "iam_assumable_role_external_dns" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.9.2"
  create_role                   = true
  role_name                     = "external-dns-role"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_external_dns_namespace}:${local.k8s_service_account_external_dns_name}"]
}

resource "aws_iam_policy" "external_dns" {
  name        = "external-dns-policy"
  description = "ExternalDNS policy for EKS cluster."

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource": [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }
  EOF
}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.12.1"

  values = [
    templatefile(
      "${path.module}/templates/external_dns.tpl.yaml",
      {
        "iam_role_arn" = module.iam_assumable_role_external_dns.iam_role_arn
        "account_name" = "external-dns"
        "zone_type"    = "public"
        "policy"       = "sync"
        "domain_name"  = var.domain_name
        "region"       = var.region
        "txt_owner_id" = "external-dns"
        "label"        = "node.k8s/scope"
        "label_value"  = "extra"
      }
    )
  ]
}
