# cloudia-4man - Cloudia as foreman
Cloudia - as foreman - accounts for providing, configuring and managing IT ressources.

## Features and supported components

All supported components are marked by their implementation state:
*  :rocket: production-ready - I use it in my own productive environment.
*  :mag: dev-mode 
*  :bulb: idea

### Provisioning Service: typically a once-only job

| Component | Description | State |
| --- | --- | :---: |

* (not tested) Raspberry Pi with Ubuntu
* (not tested) Raspberry Pi with Raspberry Pi OS
* Topton Mini PC with Ubuntu


### Configuration & Deployment Management: needs to be repeatedly done
It's done with 'ansible'.

#### Operating System (OS)

| Component | Description | State |
| --- | --- | :---: |
| Ubuntu | Ubuntu Operating System operations (with tools cURL, and VIM) |  :rocket: production-ready | 
| ArchLinux | ArchLinux Operating System operations |  :bulb: idea |
| Raspberry Pi OS | Raspberry Pi OS operations | :bulb: idea |

#### Virtual Machine Runtime Plattform

| Component | Description | State |
| --- | --- | :---: |
| Canonical Microcloud | LXD-based Virtualization Runtime |  :bulb: idea |

#### Container Runtime Plattform

| Component | Description | State |
| --- | --- | :---: |
| Suse K3s | (inspired by https://github.com/k3s-io/k3s-ansible) with storage (local-path-provisioner, Longhorn), network (Flannel), ingress (Traefik, NGINX-deprecated), and load-balancing (Kube-VIP for Kube-API AND K8s Apps) |  :rocket: production-ready |
| Canonical Microcloud | LXC-based Container Runtime |  :bulb: idea |

#### K8s Apps (platform-independent)

| Component | Description | State | Recommendation |
| --- | --- | :---: | --- |
| cert-manager | Certificate Manager for Kubernetes Ingress/Services |  :rocket: production-ready |  ⭐ |
| Gatus | Monitoring Solution |  :rocket: production-ready |  ⭐ |
| Home Assistant | Smart Home (with HACS support) |  :rocket: production-ready |  ⭐ |
| Mosquitto | MQTT Broker |  :rocket: production-ready |  ⭐ |
| Zigbee2MQTT | Zigbee to MQTT Bridge |  :rocket: production-ready |  ⭐ |
| TaskView | It combines task management, custom workflows, developer integrations, analytics, and AI-assisted automation in a platform you can run on your own infrastructure. (https://github.com/Gimanh/taskview-community) |  :bulb: idea | |
| SilverBullet | Personal Knowledge Management (see https://silverbullet.md/) |  :bulb: idea | |
| CloudNativePG (CNPG) | PostgreSQL Database for any K8s app |  :mag: dev-mode | |
| Kubernetes Reflector | Reflector for Kubernetes ConfigMaps and Secrets (original use case didn't work as expected - therefore postponed) |  :mag: dev-mode | |
| Karakeep |  |  :bulb: idea | |
| Immich | Photo Management like Google Photos |  :bulb: idea | |
| SearXNG | Search machine proxy |  :bulb: idea | |
| Seafile | File-Sharing like Dropbox or OneDrive |  :bulb: idea | |
| Jellyfin | Media and Streaming Service, like Netflix or Spotify |  :bulb: idea | |
| Kimai | timetracker (working hours, holidays, ...) |  :bulb: idea | |
| Dex | Light-weight Identity Broker (because everyone already has a preferred Identity Provider - like Microsoft Entra ID, Google Identity, or your local Synology User Directory) |  :bulb: idea | |
| Authentik | Light-weight Identity and Access Management |  :bulb: idea | |
| Authelia | Light-weight Identity and Access Management |  :bulb: idea |  ⭐ |
| rauthy | Light-weight Identity and Access Management |  :bulb: idea | |
| Vaultwarden | Bitwarden compatible Password Manager (other solution: Keepass with database hosting on Seafile or local NAS) |  :bulb: idea | |
| NetBird | Secure Access to Kubernetes Resource Access (Nodes, Pods, Services, see https://netbird.io/knowledge-hub/using-netbird-for-kubernetes-access) |  :bulb: idea | |
| Headlamp | Kubernetes Dashboard (idea from https://raveeshagarwal.medium.com/building-the-observability-stack-for-my-4-node-homelab-kubernetes-cluster-with-headlamp-and-beszel-b48fa73674ea) |  :bulb: idea | |
| Hermes-Agent | Self-improving AI agent (https://github.com/nousresearch/hermes-agent) |  :bulb: idea | |

#### Linux Apps (platform-independent)

| Component | Description | State | Recommendation |
| --- | --- | :---: | --- |
| NetBird Hub / Agent | Secure Access Platform (https://netbird.io/) |  :bulb: idea | |
| FlexiWAN |  Open Source SD-WAN & SASE (! critical license !) |  :bulb: idea | |
| Beszel | Lightweight server monitoring platform built on PocketBase (idea from https://raveeshagarwal.medium.com/building-the-observability-stack-for-my-4-node-homelab-kubernetes-cluster-with-headlamp-and-beszel-b48fa73674ea) |  :bulb: idea | |


#### Admin Tools (Linux-dependent)

| Component | Description | State | Recommendation |
| --- | --- | :---: | --- |
| k9s | Kubernetes CLI To Manage Your Clusters In Style (https://k9scli.io/) |  :rocket: production-ready |
| kubectl | K8s/K3s Console Tool |  :rocket: production-ready |  ⭐ |
| mqttx | MQTT Client |  :rocket: production-ready | |
| etcdctl | ETCD Console Tool |  :mag: dev-mode | |
| trufflehog | most powerful secrets Discovery, Classification, Validation, and Analysis tool|  :mag: dev-mode | |
| k8sgpt | AI-powered tool that helps diagnose and fix Kubernetes issues with intelligent insights and automated troubleshooting |  :mag: dev-mode | |
| Kubescape | Security Scanning for Your Cluster |  :bulb: idea | ⭐ |
| Popeye | Popeye scans a live cluster and grades it from A to F, surfacing misconfigurations that quietly accumulate over time. |  :bulb: idea |   |

## Architecture

* Inventory
  * Multiple environments with Ansible inventories
* Orchestration Service: Shell script cloudia-4man.sh
  * controls Provisioning Service ( :mag: dev-mode ) and Configuration & Deployment Management ( :rocket: production-ready)
* Provisioning Service: cloud-init ( :mag: dev-mode )
  * stages Infrastructure like Bare Metal Server (e.g. Raspberry Pi, Topton Mini-PC) based on initial state definition
* Configuration & Deployment Management: Ansible ( :rocket: production-ready)
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

## Feature Request

### Never ever
* *rr-Stack: It seems, that all components of *rr-Stack are calling home. I don't like that.
