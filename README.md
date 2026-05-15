# cloudia-4man - Cloudia as foreman
Cloudia - as foreman - accounts for providing, configuring and managing IT ressources.

## Features and supported components

* Provisioning Service: typically a once-only job
  * (not tested) Raspberry Pi with Ubuntu
  * (not tested) Raspberry Pi with Raspberry Pi OS
  * Topton Mini PC with Ubuntu
* Configuration & Deployment Management: needs to be repeatedly done
  * OS Ubuntu (with tools cURL, and VIM)
  * (not implemented) OS Raspberry Pi OS
  * (not implemented) Canonical Microcloud
  * Suse K3s (inspired by https://github.com/k3s-io/k3s-ansible)
  * K8s Apps:
    * cert-manager
    * Zigbee2MQTT
    * Home Assistant: Smart Home
    * Mosquitto: MQTT Broker
    * Gatus: Monitoring Solution
    * (not implemented) Karakeep
    * (not implemented) Immich
    * (not implemented) Time-Management
    * (not implemented) rauthy
  * Admin Tools
    * kubectl: K8s/K3s Console Tool
    * mqttx: MQTT Client
    * (not final implemented) etcdctl: ETCD Console Tool
    * (not final trufflehog)

## Architecture

* Orchestration Service: Shell script
  * controls Provisioning Service and Configuration & Deployment Management
  * manages Inventory (Infrastructure as Code)
* Provisioning Service: Ansible
  * stages Infrastructure like Bare Metal Server (Raspberry Pi) based on initial state definition
* Configuration & Deployment Management: Ansible
  * installs and updes Middleware, Software, and so on based on recommendation
  * configures Middleware, Software, and so on based on Best-Practice guidelines

## Functionality

### New infrastructure component
1. Define a new infrastructure component based on the template in folder /inventory
   1. copy the folder /0-template and name it using your environment name.
   2. describe your environment within file environment.yaml
2. Run Orchestration Service shell script cloudia-4man.sh
   1. Orchestration Service detects new infrastructure component, asks about any special parameters like one-time-passwords, or similar,
      run provisioning service, and start configuration & deployment management.

# Further reading
* https://blog.devgenius.io/provisioning-vs-configuration-management-with-terraform-4bf07b9c79db
* Why Terraform and Ansible? -> https://serverfault.com/questions/1022690/is-it-possible-to-run-ansible-on-a-bare-metal
* Using YAML instead INI -> https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#inventory-aliases

