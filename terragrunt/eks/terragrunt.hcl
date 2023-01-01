terraform {
  source = "../../modules//eks/"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path                             = "../vpc/"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"] # Configure mock outputs for the "init", "validate", "plan" commands that are returned when there are no outputs available (e.g the module hasn't been applied yet.)
  mock_outputs = {
    vpc_id          = "vpc-fake-id"
    private_subnets = ["private-fake-subnet"]
    intra_subnets   = ["intra-fake-subnet"]
  }
}

inputs = {
  cluster_version = "1.24"
  vpc_id          = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.private_subnets
  intra_subnets   = dependency.vpc.outputs.intra_subnets
}
