output "vpc_id" {
  value = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "private_subnets" {
  value = module.vpc.private_subnets
  description = "A list of private subnets inside the VPC."
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
  description = "List of IDs of intra subnets."
}
