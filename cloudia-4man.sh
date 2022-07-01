# cloudia-4man: Orchestration Service
#
# Contact: github.com/0x01af
# License: need to be improved
# Version: v2022-delta

# Configuration
C4M_CONFIG = {
 ansible_version: x.y,
 inventory_path: './inventory'
}

# Checking prerequisite
# - ansible: if not existing, should it install it

# NOT NEEDED: Detecting new infrastructure component
# - scan directory "/inventory"
# - new environment found, if a subfolder of "/inventory" isn't listed in file "/inventory/.c4m-inventory.yaml"
# - new server found, if a subfolder of "/inventory/environment" isn't listed in file "/inventory/.c4m-inventory.yaml"

# Asking about any special parameters like one-time-passwords, or similar


# INCLUDED AT ANSIBLE: Running provisioning service
mkdir /inventory/{$environment}/states/{$server}
cd /inventory/{$environment}/states/{$server}

# Starting provisioning service, and configuration & deployment management
ansible-playbook backend/ansible/playbook-main.yml -i inventory/{$environment}/environment.yaml

# Updating inventory
