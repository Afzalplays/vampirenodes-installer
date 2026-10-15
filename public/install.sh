
#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================
# VampireNodes - Control Center
# Official domain: vampirenodes.in
# ==========================================

VERSION="1.0.0"
RED='\033[0;31m'
BRIGHT_RED='\033[1;31m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RESET='\033[0m'
BOLD='\033[1m'
RED_BG='\033[41m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'


pause() {
    echo
    read -rp "Press Enter to continue..."
}




dashboard() {
    clear

    local cpu ram network hostname_name
    hostname_name=$(hostname 2>/dev/null || echo "Unknown")

    cpu=$(top -bn1 2>/dev/null |
        awk '/Cpu\(s\)/ {printf "%.0f%%", 100-$8; found=1}
             END {if (!found) printf "N/A"}')

    ram=$(free 2>/dev/null |
        awk '/Mem:/ {if ($2>0) printf "%.0f%%", $3/$2*100;
                     else print "N/A"}')

    if command -v ip >/dev/null 2>&1 &&
       ip route get 1.1.1.1 >/dev/null 2>&1; then
        network="${GREEN}● CONNECTED${RESET}"
    else
        network="${RED}● NOT CONNECTED${RESET}"
    fi

    echo -e "${BRIGHT_RED}${BOLD}"
    echo "██╗   ██╗ █████╗ ███╗   ███╗██████╗ ██╗██████╗ ███████╗"
    echo "██║   ██║██╔══██╗████╗ ████║██╔══██╗██║██╔══██╗██╔════╝"
    echo "██║   ██║███████║██╔████╔██║██████╔╝██║██████╔╝█████╗  "
    echo "╚██╗ ██╔╝██╔══██║██║╚██╔╝██║██╔═══╝ ██║██╔══██╗██╔══╝  "
    echo " ╚████╔╝ ██║  ██║██║ ╚═╝ ██║██║     ██║██║  ██║███████╗"
    echo "  ╚═══╝  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚══════╝"
    echo " ███████╗████████╗██╗   ██╗██████╗ ██╗ ██████╗ "
    echo " ██╔════╝╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗"
    echo " ███████╗   ██║   ██║   ██║██║  ██║██║██║   ██║"
    echo " ╚════██║   ██║   ██║   ██║██║  ██║██║██║   ██║"
    echo " ███████║   ██║   ╚██████╔╝██████╔╝██║╚██████╔╝"
    echo " ╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ "
    echo -e "${RESET}"

    echo -e "${WHITE}${BOLD}       CONTROL CENTER${RESET}"
    echo -e "${GRAY}       Host: ${hostname_name} | Version: ${VERSION}${RESET}"
    echo
    echo -e "${CYAN}◉ SYSTEM STATUS${RESET}"
    echo -e "   CPU Usage: ${YELLOW}${cpu}${RESET}    RAM Usage: ${YELLOW}${ram}${RESET}    Network: ${network}"
    echo
    echo -e "${MAGENTA} DEPLOYMENT & SERVICES${RESET}"
    echo -e " ${CYAN}├─ ${WHITE}[1]${RESET} VPS / System Info    ${CYAN}├─ ${WHITE}[5]${RESET} Themes"
    echo -e " ${CYAN}├─ ${WHITE}[2]${RESET} Panel                ${CYAN}├─ ${WHITE}[6]${RESET} System"
    echo -e " ${CYAN}├─ ${WHITE}[3]${RESET} Wings                ${CYAN}├─ ${WHITE}[7]${RESET} Container"
    echo -e " ${CYAN}└─ ${WHITE}[8]${RESET} New Module"
    echo
    echo -e "${MAGENTA} MAINTENANCE & TOOLS${RESET}"
    echo -e " ${CYAN}├─ ${WHITE}[4]${RESET} Toolbox              ${CYAN}└─ ${WHITE}[0]${RESET} Exit"
    echo -e " ${CYAN}└─ ${WHITE}[9]${RESET} Extras"
    echo
    echo -e "${GRAY}────────────────────────────────────────────────────────────────────────${RESET}"
}

main_menu() {
    while true; do
        dashboard
        echo
        echo -ne "${BRIGHT_RED}${BOLD} ➜ Enter Option (0-9) ${RESET}"
        read -r choice

        case "$choice" in
            1) system_info ;;
            2) panel_info ;;
            3) wings_info ;;
            4) modules_menu ;;
            5)
                echo "Themes module is not configured yet."
                pause
                ;;
            6) system_info ;;
            7)
                echo "Container management is not configured yet."
                pause
                ;;
            8)
                echo "New modules will be added here."
                pause
                ;;
            9)
                echo "Extras module is not configured yet."
                pause
                ;;
            0)
                echo -e "${GREEN}Vampire Studio shutting down the menu.${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Choose 0-9.${RESET}"
                sleep 1
                ;;
        esac
    done
}

main_menu
