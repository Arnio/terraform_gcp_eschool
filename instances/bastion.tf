resource "google_compute_instance" "bastion" {
  count        = "${var.count_bastion}"
  name         = "${var.instance_name_bastion}-${count.index}"
  machine_type = "${var.machine_type_bastion}"
  tags = ["ssh"]
  

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${var.private_subnetwork}"
    access_config = {
      }
  }
   metadata {
    sshKeys = "centos:${file("${var.public_key_path}")}"
   }
  #  provisioner "file" {
  #   source = "f:/SSHkey/devops095_ossh.pem"
  #   destination = "/home/centos/.ssh/"
  #   }

   metadata_startup_script = <<SCRIPT
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install ansible
SCRIPT
}

resource "null_resource" remoteExecProvisionerBast {
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }  
  provisioner "remote-exec" {
    inline = [ "rm -rf /tmp/ansible" ]
  }

  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }

  provisioner "file" {
    source = "f:/SSHkey/devops095_ossh.pem"
    destination = "/home/centos/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }
}
resource "null_resource" remoteExecProvisionerBastionip {
  count = "${var.count_bastion}"
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["echo ${var.instance_name_bastion}-${count.index}\tansible_ssh_host=${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index)}\tansible_user=centos\tansible_ssh_private_key_file=/home/centos/.ssh/id_rsa>>/tmp/ansible/host.txt"]
  }
}  
resource "null_resource" remoteExecProvisionerWebip {
  count = "${var.count_web}"
  connection {
    host = "${google_compute_instance.bastion.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["echo ${var.instance_name_web}-${count.index}\tansible_ssh_host=${element(google_compute_instance.web.*.network_interface.0.network_ip, count.index)}\tansible_user=centos\tansible_ssh_private_key_file=/home/centos/.ssh/id_rsa>>/tmp/ansible/host.txt"]
  }  

}