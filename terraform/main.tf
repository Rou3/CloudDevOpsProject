module "network" {
  source = "./modules/network"
}

module "server" {
  source        = "./modules/server"
  subnet_id     = module.network.subnet_id
  vpc_id        = module.network.vpc_id
  instance_type = var.instance_type
  key_name      = var.key_name
}

