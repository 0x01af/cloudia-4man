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

c4m_main() {
  # --- Hauptmenü ---
  echo "Willkommen bei meiner kleinen Konsolen-App!"

  # PS3 ist der Prompt, der vor der Menüauswahl angezeigt wird.
  PS3="Bitte wähle eine Option (1-4): "

  # Optionen für das select-Menü
  options=("Install" "Update" "Change" "Remove" "Exit")

  # Die select-Schleife zeigt das Menü an und wartet auf Eingabe
  select opt in "${options[@]}"
  do
    # REPLY enthält die Nummer der Auswahl, opt den Text der Auswahl
    case $opt in
        "(1) Betriebssysteme ")
            echo "Du hast '$opt' gewählt."
            task_mit_fortschritt 5 # Task soll 5 Sekunden dauern
            ;;
        "Einfachen Task starten")
            echo "Du hast '$opt' gewählt."
            einfacher_task
            ;;
        "Hilfe anzeigen")
            echo "Dies ist eine Beispiel-App."
            echo "Wähle einen Task oder 'Exit' zum Beenden."
            ;;
        "Exit")
            echo "Anwendung wird beendet."
            return 0 # Verlässt die select-Schleife (und damit das Skript)
            ;;
        *) # Wird ausgeführt, wenn eine ungültige Nummer eingegeben wurde
           echo "Ungültige Option: $REPLY. Bitte wähle eine Nummer von 1 bis ${#options[@]}."
           ;;
      esac
      # Wichtig: Nach jeder Aktion erneut den Prompt anzeigen lassen (standardmäßig bei select)
      # Manchmal ist es hilfreich, hier noch eine Leerzeile auszugeben oder auf "Enter" zu warten
      cls
      # read -p "Drücke Enter, um zum Menü zurückzukehren..." dummy_var

   done # Ende der select-Schleife
}

cls
echo "Cloudia wishes a good day."
exit 0


# INCLUDED AT ANSIBLE: Running provisioning service
# mkdir /inventory/{$environment}/states/{$server}
# cd /inventory/{$environment}/states/{$server}

# Starting provisioning service, and configuration & deployment management
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --ask-vault-pass

## do os_basic_only: like os updates and so on.
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --tags "os_basic_only" --ask-vault-pass

## do k8s_apps_only: like k8s apps deployment and updatek8s apps deployment and updates
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --tags "k8s_apps_only" --ask-vault-pass



# Hilfsfunktion zum Ausführen von Ansible
c4m_run_ansible() {
    local env=$1
    local tag_arg=$2
    local cmd="ansible-playbook backend/ansible/c4m-playbook.yaml -i ${C4M_CONFIG[inventory_path]}/$env/environment.yaml --ask-vault-pass"
    
    if [ -n "$tag_arg" ]; then
        cmd="$cmd --tags \"$tag_arg\""
    fi
    
    echo -e "\n--- Starte: $env ---"
    echo "Kommando: $cmd"
    # Führe das Kommando tatsächlich aus:
    eval $cmd
}

# ==============================================================================
# SUB-SUBMENU: All Environments
# ==============================================================================
show_sub_sub_menu_all() {
    clear
    echo "=== Configure All Environments ==="
    echo "0 Full run"
    echo "1 OS Basic only run"
    echo "2 K8s Apps only run"
    echo "-----------------------------------"
    read -p "Wahl: " ssc

    case $ssc in
        0)
            for env in "${C4M_ENVIRONMENTS[@]}"; do run_ansible "$env" ""; done
            return 0 # Signal zum Hauptmenu zurückzukehren
            ;;
        1)
            for env in "${C4M_ENVIRONMENTS[@]}"; do run_ansible "$env" "os_basic_only"; done
            return 0
            ;;
        2)
            for env in "${C4M_ENVIRONMENTS[@]}"; do run_ansible "$env" "k8s_apps_only"; done
            return 0
            ;;
        *) echo "Ungültige Wahl."; sleep 1; return 1 ;;
    esac
}

# ==============================================================================
# CHOICE: Environment(s)
# ==============================================================================
c4m_choice_environments() {
    local action=$1
    while true; do
        clear
        echo "Choose environment(s) for " $action
        echo "--------------------------------------------"
        echo "a All environments"
        
        # Auflistung der dynamischen Liste
        local i=1
        for env in "${C4M_ENVIRONMENTS[@]}"; do
            echo "$i $env"
            ((i++))
        done
        
        echo "q Quit (Back to Main)"
        echo "--------------------------------------------"
        read -p "Wahl: " choice_environment
        
        if [[ "$choice_environment" == "a" ]]; then
            show_sub_sub_menu_all
            break
        elif [[ "$choice_environment" == "q" ]]; then
            break
        elif [[ "$sub_choice" =~ ^[0-9]+$ ]] && [ "$sub_choice" -ge 1 ] && [ "$sub_choice" -le "${#C4M_ENVIRONMENTS[@]}" ]; then
            # Einzelne Umgebung ausgewählt (Index ist Wahl-1)
            local selected_env="${C4M_ENVIRONMENTS[$((sub_choice-1))]}"
            echo "Einzel-Modus für $selected_env gewählt (keine spezifische Logik definiert, führe Full Run aus)..."
            run_ansible "$selected_env" ""
            read -p "Drücke Enter für Hauptmenü..."
            break
        fi
    done
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
c4m_main() {
  while true; do
    clear
    echo "=== Main Menu ==="
    echo "1 Configure and Update environments..."
    echo "2 Shutdown environments..."
    echo "q Quit"
    echo "-----------------------------------"
    read -p "Auswahl: " choice_action

    case $choice_action in
        1)
            c4m_choice_environments "configure and update"
            ;;
        2)
            c4m_choice_environments "shutdown"
            ;;
        q)
            exit 0
            ;;
        *)
            echo "Ungültige Option."
            sleep 1
            ;;
    esac
  done
}

c4m_main
echo "Cloudia wishes a good day."
exit 0
