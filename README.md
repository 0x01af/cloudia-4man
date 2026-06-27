# cloudia-4man - Cloudia as foreman
Cloudia - as foreman - accounts for providing, configuring and managing IT ressources.

## Features and supported components

* Provisioning Service: typically a once-only job
  * (not tested) Raspberry Pi with Ubuntu
  * (not tested) Raspberry Pi with Raspberry Pi OS
  * Topton Mini PC with Ubuntu
* Configuration & Deployment Management: needs to be repeatedly done
  * OS
    * Ubuntu (with tools cURL, and VIM)
    * (not implemented) ArchLinux
    * (not implemented) Raspberry Pi OS
  * Virtual Machine Plattform
    * (not implemented) Canonical Microcloud
  * Container Runtime Plattform
    * (not implemented) Canonical Microcloud
    * Suse K3s (inspired by https://github.com/k3s-io/k3s-ansible) with storage (local-path-provisioner, Longhorn), network (Flannel), ingress (Traefik, NGINX-deprecated), and load-balancing (Kube-VIP for Kube-API AND K8s Apps)
  * K8s Apps:
    * cert-manager: Certificate Manager for Kubernetes Ingress/Services
    * (not implemented) CloudNativePG (CNPG): PostgreSQL Database for any K8s app
    * (not fully implemented) Kubernetes Reflector: Reflector for Kubernetes ConfigMaps and Secrets (original use case didn't work as expected - therefore postponed)
    * Zigbee2MQTT: Zigbee2MQTT Bridge
    * Home Assistant: Smart Home (with HACS support)
    * Mosquitto: MQTT Broker
    * Gatus: Monitoring Solution
    * (not implemented) Karakeep
    * (not implemented) Immich: Photo Management like Google Photos
    * (not implemented) SearXNG: Search machine proxy
    * (not implemented) Seafile: File-Sharing like Dropbox or OneDrive
    * (not implemented) Jellyfin: Media and Streaming Service, like Netflix or Spotify
    * (not implemented) Time-Management
    * (not implemented) Dex: Light-weight Identity Broker (because everyone already has a preferred Identity Provider - like Microsoft Entra ID, Google Identity, or your local Synology User Directory)
    * (not implemented) Authentik / Authelia / rauthy: Light-weight Identity and Access Management
    * (not implemented) Vaultwarden: Bitwarden compatible Password Manager (other solution: Keepass with database hosting on Seafile or local NAS)
    * (not implemented) NetBird: Secure Access to Kubernetes Resource Access (Nodes, Pods, Services, see https://netbird.io/knowledge-hub/using-netbird-for-kubernetes-access)
    * (not implemented) Headlamp: Kubernetes Dashboard (idea from https://raveeshagarwal.medium.com/building-the-observability-stack-for-my-4-node-homelab-kubernetes-cluster-with-headlamp-and-beszel-b48fa73674ea)
    * (not implemented) Hermes-Agent: Self-improving AI agent (https://github.com/nousresearch/hermes-agent)
  * Linux Apps
    * (not implemented) NetBird Hub / Agent - Secure Access Platform (https://netbird.io/)
    * (not implemented) FlexiWAN
    * (not implemented) Beszel - Lightweight server monitoring platform built on PocketBase (idea from https://raveeshagarwal.medium.com/building-the-observability-stack-for-my-4-node-homelab-kubernetes-cluster-with-headlamp-and-beszel-b48fa73674ea)
  * Admin Tools
    * kubectl: K8s/K3s Console Tool
    * mqttx: MQTT Client
    * (not final implemented) etcdctl: ETCD Console Tool
    * (not final trufflehog)

## Architecture

* Inventory
  * Multiple environments with Ansible inventories
* Orchestration Service: Shell script cloudia-4man.sh
  * controls Provisioning Service and Configuration & Deployment Management
* Provisioning Service: Ansible
  * stages Infrastructure like Bare Metal Server (Raspberry Pi) based on initial state definition
* Configuration & Deployment Management: Ansible
  * installs and updes Middleware, Software, and so on based on recommendation
  * configures Middleware, Software, and so on based on Best-Practice guidelines

## Functionality

### New environment
1. Define a new environment based on the template in folder /inventory
   1. copy the folder /0-template and name it using your environment name.
   2. describe your environment within file environment.yaml
   3. configure your components by variables under group_vars and host_vars
2. Run Orchestration Service shell script cloudia-4man.sh
   1. Orchestration Service detects new infrastructure component, asks about any special parameters like one-time-passwords, or similar,
      run provisioning service, and start configuration & deployment management.

# Further reading
* https://blog.devgenius.io/provisioning-vs-configuration-management-with-terraform-4bf07b9c79db
* Why Terraform and Ansible? -> https://serverfault.com/questions/1022690/is-it-possible-to-run-ansible-on-a-bare-metal
* Using YAML instead INI -> https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#inventory-aliases
* Kubernetes Deployments: Stop using CPU limits, set Memory limit equals to requested: https://home.robusta.dev/blog/stop-using-cpu-limits / https://medium.com/@danielvalev/stop-setting-kubernetes-cpu-limits-yes-really-285dbdf8ff51

