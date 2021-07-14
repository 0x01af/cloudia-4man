# Raspberry Pi Terraform Provisioning Service
# -------------------------------------------
# This is a run-once bootstrap Terraform Provisioning Service for a Raspberry Pi.
# Provisioning Services by default run only at resource creation, additional runs without cleanup may introduce problems.
# https://www.terraform.io/docs/provisioners/index.html

# provider "" { }

module "rpi_basic" {
  source = "../../rpi_basic"
}

# module "rpi_k3s_master" {
#  source = "../../rpi_k3s_master"
#}