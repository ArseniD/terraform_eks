app_name  = "app"
app_image = "nginxdemos/hello"

cluster_name          = "eks-cluster"
cluster_version       = "1.24"
cluster_issuer_secret = "letsencrypt-prod"

vpc_name = "k8s-vpc"
vpc_cidr = "10.0.0.0/16"

aws_region = "eu-west-1"

app_namespace        = "dev"
cm_namespace         = "cm"
ic_namespace         = "ingress-nginx"
monitoring_namespace = "monitoring"

domain_name = "arsenidudko.link"
subdomain   = "test"
