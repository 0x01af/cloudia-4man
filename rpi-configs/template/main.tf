# Raspberry Pi Terraform Provisioning Service
# -------------------------------------------
# This is a run-once bootstrap Terraform Provisioning Service for a Raspberry Pi.
# Provisioning Services by default run only at resource creation, additional runs without cleanup may introduce problems.
# https://www.terraform.io/docs/provisioners/index.html

# provider "" { }

module "rpi_basic" {
  source = "../../rpi_basic"
  
  rpi_ip4_temporary = "192.168.0.10"
  
  rpi_hostname = "hostname-new"
  rpi_ip4 = "192.168.0.20"
  rpi_ip4_netprefix = "24"
  rpi_ip6 = "2a02:"

}

# module "rpi_k3s_master" {
#  source = "../../rpi_k3s_master"
#}