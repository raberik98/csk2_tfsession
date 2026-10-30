locals {
  ec2_instances = {
    for ec2 in var.instances:
      ec2.name => ec2
  }
}

module "keys" {
  source = "./modules/keys"

  keys = var.keys
}

module "networking" {
  source = "./modules/networking"

  vpc_name = var.vpc.name
  vpc_cidr_block = var.vpc.cidr_block
  vpc_tags = var.vpc.tags
  NAT_subnet = var.vpc.NAT_subnet
  project_name = var.project_name
  region = var.aws_region
  eks_cluster_name = var.eks_cluster_name

  subnets = var.vpc.subnets
}

module "ec2" {
  source = "./modules/ec2"
  for_each = local.ec2_instances

  name = each.value.name
  type = each.value.type
  ami = each.value.ami
  instance_type = each.value.instance_type
  key_name = module.keys.keys[each.value.key_name].key_name
  subnet_id = module.networking.all_subnets[each.value.subnet_name].id
  vpc_id = module.networking.vpc.id
  tags = each.value.tags
}


module "eks" {
  source = "./modules/eks"
  aws_profile = var.aws_profile
  aws_region = var.aws_region

  name = var.eks_cluster_name
  subnet_ids = [ for sn in module.networking.all_subnets_list : sn.val.id if contains(var.eks_cluster.subnets, sn.name) ]
  k8s_version = var.eks_cluster.version
  vpc_id = module.networking.vpc.id

  node_groups = [ for ng in var.eks_cluster.node_groups: {
    name = ng.name
    labels = ng.labels
    subnet_ids = [ for sn in module.networking.all_subnets_list : sn.val.id if contains(ng.subnets, sn.name) ]
  }]

  configure_kubectl = var.eks_cluster.configure_kubectl ? { aws_region = var.aws_region, aws_cli_profile = var.aws_profile } : {}
}