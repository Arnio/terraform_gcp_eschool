output "public_ip_nat" {
   value = ["${module.network.public_ip_nat}"]
}

output "private_subnetwork_name" {
   value = ["${module.network.private_subnetwork_name}"]
}
output "ip_bastion" { 
   value = ["${module.instance.public_ip_bastion}"]
}