terraform {
  source = "../../modules//vpc/"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_cidr = "10.0.0.0/16"
}
