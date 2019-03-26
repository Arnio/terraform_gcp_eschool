provider "google" {
  credentials = "${file("${var.key}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}

module "network"{
  source = "./vpc"
  project = "${var.project}"
  region = "${var.region}"
  countnat = "2"
  ip_cidr_range_private = "10.0.12.0/24"

#   nat_id = "${module.instance.nat_id}"
#   availability_zones = "${data.aws_availability_zones.available.names}"
#   ita_group = "${var.ita_group}"
#   key_name = "${var.key_name}"
}

module "sql" {
  source = "./mysql"
  project = "${var.project}"
  region = "${var.region}"
  database_version = "MYSQL_5_7"
  tier = "db-f1-micro"
  db_instance_name = "${var.project}-db-instance128"
  disk_autoresize = true
  disk_size = 10
  disk_type = "PD_SSD"
  db_name  = "eschooldb"
  db_charset = "utf8"
  db_collation = "utf8_general_ci"
  user_name = "root"
  user_host = "%"
  user_password = "devops095eSchool"
  count = "${var.countnat}"
  compute_address = "${module.network.subnet_ids}"
}   

module "instance" {
  source = "./instances"
  public_key_path = "f:/SSHkey/devops095.pub"
  private_key_path = "f:/SSHkey/devops095_ossh.pem"
  image = "centos-cloud/centos-7"
  instance_name_web = "web"
  count_web = "2"
  machine_type_web = "g1-small"
  instance_name_bastion = "bastion"
  machine_type_bastion = "g1-small"
  count_bastion = "1"
  private_subnetwork = "${module.network.private_subnetwork_name[0]}"
}

#  module "balancer" {
#    source = "./balancer"
#    project = "${var.project}"
#    region = "${var.region}"
#    web_link = "${module.instance.web_self_link}"
#  }

# module "buckets" {
#   source = "./gbuckets"
#   project_name = "${var.project}"
# }



#   private_subnet_id = "${module.network.private_subnet_id}"
#   efs_sg_id = "${module.network.efs_sg_id}"


#}