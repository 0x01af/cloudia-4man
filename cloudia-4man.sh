#!/bin/bash
# cloudia-4man: Orchestration Service
#
# Contact: github.com/0x01af
# License: need to be improved
# Version: v2026-delta
# based on:
# - https://linuxize.com/post/bash-functions/

# Configuration
C4M_CONFIG = {
 ansible_version: "2.7",
 inventory_path: './inventory'
}

# Checking prerequisite
# - ansible: if not existing, should it install it
# - ansible collections: ensure, all required collections are installed
ansible-galaxy collection install -r backend/ansible/requirements.yaml
# - python libraries: ensure, all required python libraries are installed
pip install --user passlib

## Main Functions
# Provision: Neues Gerät / Software installieren -> updates inventory
# Configure: Geräte/Software konfigurieren/installieren
# Update: Geräte/Software aktualisieren
# Change: Geräte/Software verändern
# Remove: Geräte/Software entfernen

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


# NOT NEEDED: Detecting new infrastructure component
# - scan directory "/inventory"
# - new environment found, if a subfolder of "/inventory" isn't listed in file "/inventory/.c4m-inventory.yaml"
# - new server found, if a subfolder of "/inventory/environment" isn't listed in file "/inventory/.c4m-inventory.yaml"

# Asking about any special parameters like one-time-passwords, or similar


# INCLUDED AT ANSIBLE: Running provisioning service
# mkdir /inventory/{$environment}/states/{$server}
# cd /inventory/{$environment}/states/{$server}

# Starting provisioning service, and configuration & deployment management
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --ask-vault-pass

## do os_basic_only: like os updates and so on.
# ansible-playbook backend/ansible/c4m-playbook.yaml -i inventory/{$environment}/environment.yaml --tags "os_basic_only" --ask-vault-pass

# Updating inventory
