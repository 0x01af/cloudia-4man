#!/bin/bash
# cloudia-4man: Orchestration Service
#
# Contact: github.com/0x01af
# License: need to be improved
# Version: v2026-delta
# based on:
# - https://linuxize.com/post/bash-functions/

### Configuration
# Konstanten als assoziatives Array (Benötigt Bash 4.0+)
declare -A C4M_CONFIG
C4M_CONFIG=(
    [ansible_version]="2.7"
    [inventory_path]="./inventory"
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
# Funktion für einen Task mit einfachem Fortschrittsbalken
c4m_install() {
  local duration=$1
  local total_steps=20 # Anzahl der Schritte für den Balken
  local bar_width=50   # Breite des Balkens in Zeichen

  echo "Führe Task 1 aus (Dauer: ${duration}s)..."

  for i in $(seq 1 $total_steps); do
    # Berechne Fortschritt
    local percent=$(( 100 * i / total_steps ))
    local filled_width=$(( bar_width * i / total_steps ))
    local empty_width=$(( bar_width - filled_width ))

    # Erstelle Balken-String
    local bar=$(printf "%${filled_width}s" "" | tr ' ' '#')
    local empty=$(printf "%${empty_width}s" "")

    # Gib Balken aus (mit \r, um die Zeile zu überschreiben)
    printf "\r[%-${bar_width}s] %d%%" "${bar}${empty}" $percent

    # Simuliere Arbeit
    sleep $(echo "$duration / $total_steps" | bc -l)
  done

  # Zeilenumbruch nach Beendigung des Balkens
  echo
  echo "Cloudia's install task has been done."
}


c4m_update() {
  echo "Cloudia - the foreman - is updating..."
  sleep 2 # Simuliere Arbeit
  echo "Cloudia's update task has been done."
}


c4m_change() {
  echo "Cloudia - the foreman - is changing..."
  sleep 2 # Simuliere Arbeit
  echo "Cloudia's change task has been done."
}

c4m_remove() {
  echo "Cloudia - the foreman - is removing..."
  sleep 2 # Simuliere Arbeit
  echo "Cloudia's remove task has been done."
}


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
# Run ansible ...
# ==============================================================================
c4m_run_ansible() {
  local action=$1
  local scope=$2
  local env=$3

  local cmd="ansible-playbook backend/ansible/c4m-$action.yaml -i ${C4M_CONFIG[inventory_path]}/$env/environment.yaml --ask-vault-pass"
  
  if [ "$scope" != "any" ]; then
    cmd="$cmd --tags \"$scope\""
  fi

  echo "Cloudia - the foreman - executes command: $cmd"
  eval $cmd
}

# ==============================================================================
# Execute action on environments ...
# ==============================================================================
c4m_action() {
  local action="${1}"
  local scope="${2:-any}"

  while true; do
    clear
    echo "Cloudia - the foreman executes " $action " (scope: " $scope ") on ..."
    echo "------------------------------------------------------------------------------------------"
    echo "a) All environments"
    # Auflistung der dynamischen Liste
    local i=1
    for env in "${C4M_ENVIRONMENTS[@]}"; do
      echo "$i) $env"
      ((i++))
    done
    echo "q) Quit (back to main)"
    echo "------------------------------------------------------------------------------------------"
    read -p "Choose environment(s): " environment
    
    if [[ "$environment" == "q" ]]; then
      break
    elif [[ "$environment" == "a" ]]; then
      for env in "${C4M_ENVIRONMENTS[@]}"; do
        c4m_run_ansible $action $scope $env
      done
      break
    elif [[ "$environment" =~ ^[0-9]+$ ]] && [ "$environment" -ge 1 ] && [ "$environment" -le "${#C4M_ENVIRONMENTS[@]}" ]; then
      # Einzelne Umgebung ausgewählt (Index ist Wahl-1)
      local env="${C4M_ENVIRONMENTS[$((environment-1))]}"
      c4m_run_ansible $action $scope $env
      break
    fi
  done
}

# ==============================================================================
# Choose execution scope ...
# ==============================================================================
c4m_scope() {
  clear
  echo "------------------------------------------------------------------------------------------"
  echo "1) OS Basic only run"
  echo "2) K8s Apps only run"
  echo "any) any scope"
  echo "------------------------------------------------------------------------------------------"
  read -p "Choose execution scope..." scope
  
  case $scope in
    1) return "os_basic_only" ;;
    2) return "k8s_apps_only" ;;
    *) return "any" ;;
  esac
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
c4m_main() {
  while true; do
    clear
    echo "Cloudia - the foreman - welcomes you."
    echo "------------------------------------------------------------------------------------------"
    echo "1) Execute playbook ..."
    echo "2) Execute shutdown ..."
    echo "q) Quit (Exit)"
    echo "------------------------------------------------------------------------------------------"
    read -p "Choose an action ..." action
    
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
