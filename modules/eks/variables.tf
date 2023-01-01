variable "cluster_version" {
  type        = string
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster."
}

variable "deployment_prefix" {
  type        = string
  description = "Deployment prefix."
}

variable "intra_subnets" {
  type = list(string)
  description = "List of IDs of intra subnets."
}

variable "private_subnets" {
  type = list(string)
  description = "A list of private subnets inside the VPC."
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC."
}
