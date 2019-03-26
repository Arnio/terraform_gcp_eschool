resource "google_compute_instance" "web" {
  count        = "${var.count_web}"
  name         = "${var.instance_name_web}-${count.index}"
  machine_type = "${var.machine_type_web}"
  tags = ["ssh","web"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${var.private_subnetwork}"
  }
 
  metadata_startup_script = <<SCRIPT
sudo yum -y update
   #Install httpd
sudo yum -y install httpd
sudo systemctl start httpd


SCRIPT

  metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
  }

}
