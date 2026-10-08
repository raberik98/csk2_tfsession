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