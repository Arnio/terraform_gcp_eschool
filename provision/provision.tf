resource "null_resource" remoteExecProvisionerBast {
  connection {
    host = "${var.bastion_public_ip}"
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

resource "null_resource" remoteExecProvisionerWebip {
  depends_on = ["null_resource.remoteExecProvisionerBast"]
 # count = "${var.count_web}"
  count = "1"
  connection {
    host = "${var.bastion_public_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["echo \"[web]\n${var.instance_name_web}-[0:${var.count_web}]\t\">>/tmp/ansible/host.txt"]
  }  
  provisioner "remote-exec" {
    inline = ["echo \"[web]\n${var.instance_name_web}-[0:${var.count_web}]\t\">>/tmp/ansible/host.txt"]
  }

}
resource "null_resource" remoteExecProvisionerAnsible {
  depends_on = ["null_resource.remoteExecProvisionerWebip"] 
  connection {
    host = "${var.bastion_public_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["ansible-playbook /tmp/ansible/main.yml -i /tmp/ansible/host.txt"]
  }
}  