output "public_ip_nat" {
   value = ["${google_compute_address.address.*.address}"]
}

output "private_subnetwork_name" {
   value = "${google_compute_subnetwork.private_subnetwork.*.name}"
}
output "subnet_ids" { 
   value = "${join(",", google_compute_address.address.*.address)}" 
}
