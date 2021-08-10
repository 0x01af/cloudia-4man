# cloudia-4man: Orchestration Service
#
# Contact: github.com/0x01af
# License: need to be improved
# Version: v2021-delta

# Configuration
C4M_CONFIG = {
 terraform_version: x.y,
 ansible_version: x.y,
 inventory_path: './inventory'
}

# Checking prerequisite
# - terraform: if not existing, should it install it
# - ansible: if not existing, should it install it

# NOT NEEDED: Detecting new infrastructure component
# - scan directory "/inventory"
# - new environment found, if a subfolder of "/inventory" isn't listed in file "/inventory/.c4m-inventory.yaml"
# - new server found, if a subfolder of "/inventory/environment" isn't listed in file "/inventory/.c4m-inventory.yaml"

# Asking about any special parameters like one-time-passwords, or similar


# INCLUDED AT ANSIBLE: Running provisioning service
mkdir /inventory/{$environment}/states/{$server}
cd /inventory/{$environment}/states/{$server}
# - write terraform file "main.tf"
# Content:
module "os_linux" {
  source = "../../../../backend/terraform/os_linux"
  
  su_username = "${var.su_username}"
  su_password = "${var.su_password}"
  
  ip4_init = "{$ip4_init}"
  
  hostname = "{$server}"
}
#

terraform init -input=false
terraform plan -var "su_username=$username" -var "su_password=$password" -out=$server.tfplan -input=false
terraform apply -input=false $server.tfplan


# Starting provisioning service, and configuration & deployment management
ansible-playbook backend/ansible/playbook-main.yml -i inventory/{$environment}/environment.yaml

# Updating inventory
