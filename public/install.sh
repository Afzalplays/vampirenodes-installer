
#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================
# VampireNodes - Obsidian Control Center
# Official domain: vampirenodes.in
# ==========================================

VERSION="1.0.0"
RED='\033[0;31m'
BRIGHT_RED='\033[1;31m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RESET='\033[0m'

pause() {
    echo
    read -rp "Press Enter to continue..."
}



banner() {
    clear
    echo -e "${BRIGHT_RED}"
    echo "██╗   ██╗ █████╗ ███╗   ███╗██████╗ ██╗██████╗ ███████╗"
    echo "██║   ██║██╔══██╗████╗ ████║██╔══██╗██║██╔══██╗██╔════╝"
    echo "██║   ██║███████║██╔████╔██║██████╔╝██║██████╔╝█████╗  "
    echo "╚██╗ ██╔╝██╔══██║██║╚██╔╝██║██╔═══╝ ██║██╔══██╗██╔══╝  "
    echo " ╚████╔╝ ██║  ██║██║ ╚═╝ ██║██║     ██║██║  ██║███████╗"
    echo "  ╚═══╝  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚══════╝"
    echo
    echo " ███████╗████████╗██╗   ██╗██████╗ ██╗ ██████╗ "
    echo " ██╔════╝╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗"
    echo " ███████╗   ██║   ██║   ██║██║  ██║██║██║   ██║"
    echo " ╚════██║   ██║   ██║   ██║██║  ██║██║██║   ██║"
    echo " ███████║   ██║   ╚██████╔╝██████╔╝██║╚██████╔╝"
    echo " ╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ "
    echo -e "${RESET}"
    echo
    echo -e "${WHITE}          VAMPIRE STUDIO${RESET}"
    echo -e "${GRAY}        CONTROL CENTER VERSION ${VERSION}${RESET}"
    echo "========================================================"
    echo
}

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo -e "${RED}Run this option as root (or with sudo).${RESET}"
        return 1
    fi
}

system_info() {
    banner
    echo -e "${WHITE}SYSTEM INFORMATION${RESET}"
    echo "------------------------------------------------"
    printf "Hostname : "; hostname
    printf "OS       : "
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        echo "${PRETTY_NAME:-Unknown}"
    else
        echo "Unknown"
    fi
    printf "Kernel   : "; uname -r
    printf "Arch     : "; uname -m
    printf "Uptime   : "; uptime -p 2>/dev/null || uptime
    echo
    if command -v free >/dev/null 2>&1; then
        free -h
    fi
    echo
    if command -v df >/dev/null 2>&1; then
        df -h /
    fi
    pause
}

update_system() {
    banner
    echo "This option updates package lists and installed packages."
    echo "It may restart services or change system packages."
    echo
    read -rp "Continue? Type YES: " confirm
    [[ "$confirm" == "YES" ]] || return 0

    require_root || return 1

    if command -v apt-get >/dev/null 2>&1; then
        apt-get update
        apt-get upgrade -y
    elif command -v dnf >/dev/null 2>&1; then
        dnf upgrade -y
    elif command -v yum >/dev/null 2>&1; then
        yum update -y
    else
        echo "Unsupported package manager."
        pause
        return 1
    fi

    echo -e "${BRIGHT_RED}System update completed.${RESET}"
    pause
}

panel_info() {
    banner
    echo "PTERODACTYL PANEL"
    echo "------------------------------------------------"
    echo "This option is reserved for the Panel installer."
    echo
    echo "Before adding automatic installation, configure:"
    echo "  - Supported operating system"
    echo "  - Domain name and DNS"
    echo "  - HTTPS certificate"
    echo "  - Database credentials"
    echo "  - Firewall and backups"
    echo
    echo "No Panel has been installed by this menu."
    pause
}

wings_info() {
    banner
    echo "PTERODACTYL WINGS"
    echo "------------------------------------------------"
    echo "This option is reserved for the Wings installer."
    echo
    echo "Before installation, configure:"
    echo "  - Existing Pterodactyl Panel"
    echo "  - Node FQDN and DNS"
    echo "  - Daemon port and HTTPS"
    echo "  - Docker and firewall"
    echo
    echo "No Wings service has been installed by this menu."
    pause
}

modules_menu() {
    while true; do
        banner
        echo "MODULES"
        echo "------------------------------------------------"
        echo "1) System information"
        echo "2) Update system packages"
        echo "0) Back"
        echo
        read -rp "VampireNodes Modules > " choice

        case "$choice" in
            1) system_info ;;
            2) update_system ;;
            0) return ;;
            *) echo "Invalid option."; sleep 1 ;;
        esac
    done
}

main_menu() {
    while true; do
        banner
        echo " 1) VPS / System Information"
        echo " 2) Install Pterodactyl Panel (not configured)"
        echo " 3) Install Wings (not configured)"
        echo " 4) Modules"
        echo " 5) Update System Packages"
        echo " 0) Exit"
        echo
        read -rp "VampireNodes > " choice

        case "$choice" in
            1) system_info ;;
            2) panel_info ;;
            3) wings_info ;;
            4) modules_menu ;;
            5) update_system ;;
            0)
                echo "Thank you for using VampireNodes."
                exit 0
                ;;
            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

main_menu
