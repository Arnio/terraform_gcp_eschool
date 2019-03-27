output "public_ip_bastion" {
   value = ["${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"]
}
output "ip_web" {
   value = ["${google_compute_instance.web.*.network_interface.0.network_ip}"]
}

output "web_self_link" {
   value = ["${google_compute_instance.web.*.self_link}"]
}
output "web_self_link_string" { 
   value = "${join(",", google_compute_instance.web.*.self_link)}" 
}
