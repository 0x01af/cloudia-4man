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
# - pip: if not existing, install it
# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# python3 get-pip.py --user
# - ansible: if not existing, install it
# python3 -m pip install --user ansible
# - ansible collections: ensure, all required collections are installed
ansible-galaxy collection install -r backend/ansible/requirements.yaml
# - python libraries: ensure, all required python libraries are installed (https://packaging.python.org/en/latest/tutorials/installing-packages/)
python3 -m pip install -r backend/python/requirements.txt

### Main Functions
# INCLUDED AT ANSIBLE: Running provisioning service
# mkdir /inventory/{$environment}/states/{$server}
# cd /inventory/{$environment}/states/{$server}

# ==============================================================================
# Helper functions
# ==============================================================================
function c4m_aborted() {
  clear
  echo "ERROR: Program has been aborted unexpectedly!"
  echo "Cloudia hopes to get well soon."
  exit 0
}

# ==============================================================================
# Run ansible ...
# ==============================================================================
function c4m_run_ansible() {
  local action="${1}"
  local scope="${2}"
  local env="${3}"
  
  # Starting provisioning service, and configuration & deployment management
  # ansible-playbook backend/ansible/c4m-bootstrap.yaml -i inventory/{$environment}/environment.yaml --ask-vault-pass
  ## do os_basic_only: like os updates and so on.
  # ansible-playbook backend/ansible/c4m-bootstrap.yaml -i inventory/{$environment}/environment.yaml --tags "os_basic_only" --ask-vault-pass
  ## do k8s_apps_only: like k8s apps deployment and updatek8s apps deployment and updates
  # ansible-playbook backend/ansible/c4m-bootstrap.yaml -i inventory/{$environment}/environment.yaml --tags "k8s_apps_only" --ask-vault-pass
  local playbook="backend/ansible/c4m-$action.yaml"
  local inventory="${C4M_CONFIG[inventory_path]}/$env/environment.yaml"
  local tags=""
  
  if [[ -n "$scope" && "$scope" != "any" ]]; then
    $tags="$scope"
  fi
  
  clear
  printf "Cloudia - the foreman - executes an ansible-playbook with following parameters:\n"
  printf "\- playbook: $playbook\n"
  printf "\- inventory: $inventory\n"
  printf "\- tags: $scope\n"
  printf "Please stand by for any requests or warnings...\n\n"
  
  ansible-playbook "$playbook" -i "$inventory" --ask-vault-pass ${tags:+--tags "$tags"} | tee "c4m-last-run.log"
  case $? in
    0) # everything okay
       dialog --clear \
         --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
         --title "Info" \
         --msgbox "Cloudia - the foreman - was successfull.\n\nFor more information, read the last-run logfile (c4m-last-run.log)." 0 40
       ;;
    *) # everythin else
       dialog --clear \
         --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
         --title "Error" \
         --msgbox "ERROR: Cloudia - the foreman - detected an error!\n\nPlease visit the last-run logfile (c4m-last-run.log)." 0 40
       ;;
    esac
  
}

# ==============================================================================
# Execute action on environments ...
# ==============================================================================
function c4m_action() {
  local action="${1}"
  local scope="${2:-any}"
  
  local i=1
  local options=()
  for env in "${C4M_ENVIRONMENTS[@]}"; do
    options+=("$i" "$env" off)
    ((i++))
  done
  
  while true; do
    local environments
    environments=$(dialog --clear \
    --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
    --title "Inventory" \
    --extra-button --extra-label "All environments" \
    --checklist "Choose environment(s) to executing $action (scope: $scope):" 0 0 15 \
    "${options[@]}" \
    3>&1 1>&2 2>&3)
   
    case $? in
      0)  # OK was pressed
          for env in "${environments[@]}"; do
            c4m_run_ansible "$action" "$scope" "${C4M_ENVIRONMENTS[$env-1]}"
          done
          break
          ;;
      3)  # Extra button (More Info) was pressed
          for env in "${C4M_ENVIRONMENTS[@]}"; do
            c4m_run_ansible "$action" "$scope" "$env"
          done
          break
          ;;
      1 | 255)  # Cancel was pressed
          break
          ;;
    esac
  done
}

# ==============================================================================
# Choose execution scope ...
# ==============================================================================
function c4m_scope() {
  local scope=$(dialog --clear \
    --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
    --title "Playbook scope" \
    --nocancel \
    --checklist "Choose a scope: " 0 0 15 \
    "os_basic_only" "Run OS Basic only" off \
    "k8s_apps_only" "Run K8s Apps only" off \
    3>&1 1>&2 2>&3)

  if [ -z "$scope" ]; then
    echo "any"
  else
    echo "$scope" | sed 's/"//g' | tr ' ' ','
  fi
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
function c4m_main() {
  while true; do
    local action
    
    action=$(dialog --clear \
    --backtitle "${C4M_CONFIG[dialog_backtitle]}" \
    --title "Cloudia - the foreman - welcomes you." \
    --cancel-label "Exit" \
    --menu "Choose an action: " 0 0 15 \
    1 "Execute bootstrap ..." \
    2 "Execute shutdown ..." \
    3>&1 1>&2 2>&3)
    
    case $? in
      0) # OK was pressed
         case $action in
           1) local scope=$(c4m_scope)
              c4m_action "bootstrap" "$scope"
              ;;
           2) c4m_action "shutdown"
              ;;
         esac
         ;;
      1 | 255) # Cancel was pressed
         break
         ;;
    esac
  done
}

c4m_main
clear
echo "Cloudia wishes a good day."
exit 0
