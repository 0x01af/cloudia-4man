# Raspberry Pi Terraform Provisioning Service
# -------------------------------------------
# This is a run-once bootstrap Terraform Provisioning Service for a Raspberry Pi.
# Provisioning Services by default run only at resource creation, additional runs without cleanup may introduce problems.
# https://www.terraform.io/docs/provisioners/index.html

module "rpi_basic" {
  source = "../../tf-modules/rpi_basic"
  
  rpi_ip4_temporary = "192.168.123.118"
  
  rpi_hostname = "snarlk3s1"
  rpi_ip4 = "192.168.123.21/25"
  rpi_ip6 = "2a02:169:67f5:1af::21/64"
  
}

# module "rpi_k3s_master" {
#  source = "../../tf-modules/rpi_k3s_master"
#}