provider "aws" {
  region = var.region
}

module "network" {
    source = "./network"
}

module "compute" {
    source = "./compute"

    vpc_id = module.network.vpc_id
    vpc_cidr_block = module.network.vpc_cidr_block
    private_subnet_id = module.network.private_subnet_id
    management_subnet_id = module.network.management_subnet_id

    my_public_ip = var.my_public_ip

    depends_on = [ module.network ]
}
