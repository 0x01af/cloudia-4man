# Raspberry Pi Terraform Provisioning Service
# -------------------------------------------
# This is a run-once bootstrap Terraform Provisioning Service for a Raspberry Pi.
# Provisioning Services by default run only at resource creation, additional runs without cleanup may introduce problems.
# https://www.terraform.io/docs/provisioners/index.html

module "rpi_basic" {
  source = "../../tf-modules/rpi_basic"
  
  su_username = "${var.su_username}"
  su_password = "${var.su_password}"
  
  rpi_ip4_temporary = "192.168.123.Y"
  
  rpi_hostname = "hostname-new"
  rpi_ip4 = "192.168.123.X/25"
  rpi_ip6 = "2a02:169:67f5:1af::X/64"
  
}

module "rpi_k3s_server" {
  source = "../../tf-modules/rpi_k3s_server"
  
  su_username = "${var.su_username}"
  su_password = "${var.su_password}"
  
  rpi_ip4 = "192.168.123.X/25"
  
  k3s_token = "k3s-cluster-1"
  k3s_data_dir = "/mnt/nvme1/k3s/data"
}