data "aws_ami" "eks_bottlerocket" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.cluster_version}-x86_64-*"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.4.2"

  cluster_name                    = "${var.deployment_prefix}-eks-cluster"
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.intra_subnets

  eks_managed_node_group_defaults = {
    ami_id        = data.aws_ami.eks_bottlerocket.image_id
    platform      = "bottlerocket"
    capacity_type = "ON_DEMAND"
    disk_size     = 50

    enable_bootstrap_user_data = true

    pre_bootstrap_user_data = <<-EOT
        echo "Boostrap started. Installing dependencies.."
    EOT

    post_bootstrap_user_data = <<-EOT
        echo "Bootstrap done!"
    EOT
  }

  eks_managed_node_groups = {
    monitoring = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.xlarge"]

      ebs_optimized     = true
      enable_monitoring = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      bootstrap_extra_args = <<-EOT
        [settings.kernel]
        lockdown = "integrity"

        [settings.kubernetes.node-labels]
        "node.k8s/scope" = "monitoring"
      EOT

    }

    app = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.large"]

      bootstrap_extra_args = <<-EOT
        [settings.kernel]
        lockdown = "integrity"

        [settings.kubernetes.node-labels]
        "node.k8s/scope" = "application"
      EOT

    }

    ingress = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.large"]

      bootstrap_extra_args = <<-EOT
        [settings.kernel]
        lockdown = "integrity"

        [settings.kubernetes.node-labels]
        "node.k8s/scope" = "ingress"
      EOT

    }

    extra = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"]

      bootstrap_extra_args = <<-EOT
        [settings.kernel]
        lockdown = "integrity"

        [settings.kubernetes.node-labels]
        "node.k8s/scope" = "extra"
      EOT

    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      source_cluster_security_group = true
      description                   = "Allow workers pods to receive communication from the cluster control plane."
    }
    ingress_self_all = {
      description = "Allow nodes to communicate with each other"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Node all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
