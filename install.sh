
#!/usr/bin/env bash

set -Eeuo pipefail

clear

RED='\033[0;31m'
WHITE='\033[1;37m'
RESET='\033[0m'

show_banner() {
    echo -e "${RED}"
    echo "======================================"
    echo "       VAMPIRE NODES"
    echo "       OBSIDIAN CONTROL CENTER"
    echo "======================================"
    echo -e "${RESET}"
}

show_menu() {
    echo -e "${WHITE}Select an option:${RESET}"
    echo " "
    echo " 1) VPS Setup"
    echo " 2) Install Pterodactyl Panel"
    echo " 3) Install Wings"
    echo " 4) Install Modules"
    echo " 5) System Information"
    echo " 0) Exit"
    echo " "
    read -rp "VampireNodes > " choice

    case "$choice" in
        1) echo "VPS Setup selected." ;;
        2) echo "Pterodactyl Panel selected." ;;
        3) echo "Wings selected." ;;
        4) echo "Modules selected." ;;
        5) uname -a ;;
        0) exit 0 ;;
        *) echo "Invalid option." ;;
    esac
}

show_banner
show_menu
