module "networking" {
  source = "./modules/networking"

  vpc_name = var.vpc.name
  vpc_cidr_block = var.vpc.cidr_block
  vpc_tags = var.vpc.tags
  NAT_subnet = var.vpc.NAT_subnet
  project_name = var.project_name

  subnets = var.vpc.subnets
}