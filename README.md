# cloudia-4man - Cloudia as foreman
Cloudia - as foreman - accounts for providing, configuring and managing IT ressources.

## Functionality

* Provisioning Service: typically a once-only job
  * Raspberry Pi with Ubuntu
  * Raspberry Pi with Raspberry Pi OS
* Configuration & Deployment Management: needs to be repeatedly done
  * OS Ubuntu
  * OS Raspberry Pi OS
  * K3s
  * Zigbee2MQTT
  * ioBroker (Kubernetes)

## Architecture

* Orchestration Service: Shell script
** controls Provisioning Service and Configuration & Deployment Management
** manages Inventory (Infrastructure as Code)
* Provisioning Service: Terraform
* Configuration & Deployment Management: Ansible


## Further reading
* https://blog.devgenius.io/provisioning-vs-configuration-management-with-terraform-4bf07b9c79db
