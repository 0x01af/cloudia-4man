#!/bin/bash
# cloudia-4man: Orchestration Service
#
# Contact: github.com/0x01af
# License: need to be improved
# Version: v2026-delta
# based on:
# - https://linuxize.com/post/bash-functions/
# - https://github.com/RileyMeta/Bash-Dialog/blob/main/Examples/All_Menus/All_Menus.sh
trap 'c4m_aborted' INT

### Configuration
# Konstanten als assoziatives Array (Benötigt Bash 4.0+)
declare -A C4M_CONFIG=(
    [ansible_version]="2.7"
    [inventory_path]="./inventory"
    [dialog_backtitle]="Cloudia - the foreman (cloudia-4man)"
)

### Preparation
# Liste der Umgebungen (C4M_ENVIRONMENTS) dynamisch füllen
# NOT NEEDED: Detecting new infrastructure component
# - scan directory "/inventory"
# - new environment found, if a subfolder of "/inventory" isn't listed in file "/inventory/.c4m-inventory.yaml"
# - new server found, if a subfolder of "/inventory/environment" isn't listed in file "/inventory/.c4m-inventory.yaml"
C4M_ENVIRONMENTS=()
# Überprüfen, ob das Verzeichnis existiert
if [ -d "${C4M_CONFIG[inventory_path]}" ]; then
    # Scanne Unterverzeichnisse, schliesse "0-template" aus
    for dir in "${C4M_CONFIG[inventory_path]}"/*/; do
        dir_name=$(basename "$dir")
        if [[ "$dir_name" != "0-template" && "$dir_name" != "*" ]]; then
            C4M_ENVIRONMENTS+=("$dir_name")
        fi
    done
else
    echo "Warnung: Inventory-Pfad ${C4M_CONFIG[inventory_path]} nicht gefunden."
    exit 1
fi

# Checking prerequisite
# - ansible: if not existing, should it install it
# - ansible collections: ensure, all required collections are installed
ansible-galaxy collection install -r backend/ansible/requirements.yaml
# - python libraries: ensure, all required python libraries are installed
pip install --user passlib

### Main Functions
# INCLUDED AT ANSIBLE: Running provisioning service
# mkdir /inventory/{$environment}/states/{$server}
# cd /inventory/{$environment}/states/{$server}

# Starting provisioning service, and configuration & deployment management
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --ask-vault-pass

## do os_basic_only: like os updates and so on.
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --tags "os_basic_only" --ask-vault-pass

## do k8s_apps_only: like k8s apps deployment and updatek8s apps deployment and updates
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --tags "k8s_apps_only" --ask-vault-pass

# ==============================================================================
# Helper functions
# ==============================================================================
function c4m_aborted() {
  clear
  echo "ERROR: Program has been aborted unexpectedly!"
  echo "Cloudia hopes to get well soon."
  exit 0
}
function join_by { local IFS="$1"; shift; echo "$*"; }

# ==============================================================================
# Run ansible ...
# ==============================================================================
function c4m_run_ansible() {
  local action=$1
  local scope=$2
  local env=$3

  local cmd="ansible-playbook backend/ansible/c4m-$action.yaml -i ${C4M_CONFIG[inventory_path]}/$env/environment.yaml --ask-vault-pass"
  
  if [ "$scope" != "any" ]; then
    cmd="$cmd --tags \"$scope\""
  fi

  echo "Cloudia - the foreman - executes command: $cmd"
  # eval $cmd
}

# ==============================================================================
# Execute action on environments ...
# ==============================================================================
function c4m_action() {
  local action="${1}"
  local scope="${2:-any}"
  
  local i=0
  for env in "${environments[@]}"; do
    i=$((i+1))
    options+=($i "$env" off)
  done
  
  while true; do
    environments=$(dialog --clear \
    --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
    --title "Inventory" \
    --extra-button --extra-label "All environments" \ \
    --checklist "Choose environment(s) to executing $action (scope: $scope):" 0 0 15 \
    "${options[@]}" \
    3>&1 1>&2 2>&3)
    
    exit_status=$?
    
    case $exit_status in
      0)  # OK was pressed
          for env in "${environments[@]}"; do
            c4m_run_ansible $action $scope $env
          done
          break
          ;;
      3)  # Extra button (More Info) was pressed
          for env in "${C4M_ENVIRONMENTS[@]}"; do
            c4m_run_ansible $action $scope $env
          done
          break
          ;;
      1)  # Cancel was pressed
          break
          ;;
    esac
  done
}

# ==============================================================================
# Choose execution scope ...
# ==============================================================================
function c4m_scope() {
  declare -a scope=( $(dialog --clear \
    --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
    --title "Playbook scope" \
    --checklist "Choose a scope: " 0 0 15 \
    "os_basic_only" "Run OS Basic only" off \
    "k8s_apps_only" "Run K8s Apps only" off \
    2>&1 1>&2) )

  exit_status=$?
  
  case $exit_status in
    0)  # OK was pressed
        echo "${scope[@]}" >debug.log
        return join_by "," "${scope[@]}"
        ;;
    1)  # Cancel was pressed
        break
        ;;
  esac 
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
function c4m_main() {
  while true; do
    action=$(dialog --clear \
    --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
    --title "Cloudia - the foreman - welcomes you." \
    --menu "Choose an action: " 0 0 15 \
    1 "Execute playbook ..." \
    2 "Execute shutdown ..." \
    q "Quit" \
    3>&1 1>&2 2>&3)
    
    case $action in
      1)
        local scope=$(c4m_scope)
        c4m_action "playbook" $scope
        ;;
      2)
        c4m_action "shutdown"
        ;;
      q)
        break
        ;;
      *)
        echo "ERROR: Option is not available!"
        sleep 1
        ;;
    esac
  done
}

c4m_main
clear
echo "Cloudia wishes a good day."
exit 0
