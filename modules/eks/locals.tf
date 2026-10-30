locals {
  node_groups = { for ng in var.node_groups: ng.name => ng }
}