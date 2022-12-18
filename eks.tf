resource "kubernetes_namespace_v1" "eks_namespaces" {
  for_each = toset([
    var.app_namespace,
    var.ic_namespace,
    var.cm_namespace,
    var.monitoring_namespace
  ])

  metadata {
    annotations = {
      name = each.key
    }
    name = each.key
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name                    = var.cluster_name
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_version                 = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
     port_8089 = {
      description = "Cert-manager solver"
      protocol    = "tcp"
      from_port   = 8089
      to_port     = 8089
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

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "m5.large"
    update_launch_template_default_version = true
  }

  self_managed_node_groups = {
    one = {
      name         = "mixed-1"
      max_size     = 5
      desired_size = 1

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }
    }
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 0
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      # capacity_type  = "SPOT"
    }
  }

  tags = local.tags
}
