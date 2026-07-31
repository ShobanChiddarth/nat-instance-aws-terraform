output "bastion_public_ip" {
    value = module.compute.bastion_public_ip
}

output "nat_instance_public_ip" {
    value = module.compute.nat_instance_public_ip
}

output "PEC21_private_ip" {
    value = module.compute.PEC21_private_ip
}

output "PEC22_private_ip" {
    value = module.compute.PEC22_private_ip
}
