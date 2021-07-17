# Raspberry Pi K3s Server Provisioning (rpi_k3s_server)
# -----------------------------------------------------
# This is a run-once bootstrap Terraform Provisioning Service for a Raspberry Pi.
# Provisioning Services by default run only at resource creation, additional runs without cleanup may introduce problems.
# https://www.terraform.io/docs/provisioners/index.html

module "rpi_k3s_server" {
  source = "../../../tf-modules/rpi_k3s_server"
  
  su_username = "${var.su_username}"
  su_password = "${var.su_password}"
  
  rpi_ip4 = "192.168.123.21"
  
  k3s_token = "k3s-cluster-1"
  k3s_data_dir = "/mnt/nvme1/k3s/data"
}