# cloudia-4man: Orchestration Service
#
# Contact: github.com/0x01af
# License: need to be improved
# Version: v2021-delta

# Configuration
CONFIG = {
 terraform_version: x.y,
 ansible_version: x.y
}

# Checking prerequisite
# - terraform: if not existing, should it install it
# - ansible: if not existing, should it install it

# Detecting new infrastructure component


# Asking about any special parameters like one-time-passwords, or similar


# Preparing inventory


# Running provisioning service
cd /inventory/{$hostname}
terraform init
terraform plan
terraform apply


# Starting configuration & deployment management
ansible-playbook backend/ansible/cloudia-4man-playbook.yml -i inventory/cloudia-4man-ansible-inventory.yaml

