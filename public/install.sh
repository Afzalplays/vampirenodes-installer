
#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================
# VAMPIRE STUDIO - VPS CONTROL CENTER
# VampireNodes | https://codes.vampirenodes.in
# ============================================

R='\033[0;31m'
RED='\033[1;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
C='\033[0;36m'
W='\033[1;37m'
M='\033[0;35m'
D='\033[0m'

APP="VAMPIRE STUDIO"
VERSION="1.0.0"

pause() {
    echo
    read -r -p "Press Enter to continue..." _ || true
}

clear_screen() {
    clear 2>/dev/null || true
}


header() {
    clear_screen
    echo -e "${R}"
    cat <<'BANNER'
██╗   ██╗ █████╗ ███╗   ███╗██████╗ ██╗██████╗ ███████╗
██║   ██║██╔══██╗████╗ ████║██╔══██╗██║██╔══██╗██╔════╝
██║   ██║███████║██╔████╔██║██████╔╝██║██████╔╝█████╗
╚██╗ ██╔╝██╔══██║██║╚██╔╝██║██╔═══╝ ██║██╔══██╗██╔══╝
 ╚████╔╝ ██║  ██║██║ ╚═╝ ██║██║     ██║██║  ██║███████╗
  ╚═══╝  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚══════╝

 ███████╗████████╗██╗   ██╗██████╗ ██╗ ██████╗
 ██╔════╝╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗
 ███████╗   ██║   ██║   ██║██║  ██║██║██║   ██║
 ╚════██║   ██║   ██║   ██║██║  ██║██║██║   ██║
 ███████║   ██║   ╚██████╔╝██████╔╝██║╚██████╔╝
 ╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝
BANNER
    echo -e "${D}${W}              CONTROL CENTER${D}"
    echo -e "${C}          VampireNodes | By Vampire Studio${D}"
    echo -e "${R}====================================================${D}"
}

line() {
    echo -e "${R}====================================================${D}"
}

ok() {
    echo -e "${G}[OK]${D} $*"
}

warn() {
    echo -e "${Y}[!]${D} $*"
}

info() {
    echo -e "${C}[INFO]${D} $*"
}

has() {
    command -v "$1" >/dev/null 2>&1
}

not_ready() {
    warn "$1 is not configured yet."
    echo "No unverified installer will be executed."
    pause
}

show_menu() {
    header
    echo -e "${W}$1${D}"
    line
}

system_info() {
    show_menu "VPS / SYSTEM INFORMATION"

    echo -e "${C}Hostname:${D} $(hostname 2>/dev/null || echo Unknown)"
    echo -e "${C}OS:${D} $(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-Unknown}" || echo Unknown)"
    echo -e "${C}Kernel:${D} $(uname -r 2>/dev/null || echo Unknown)"
    echo -e "${C}Architecture:${D} $(uname -m 2>/dev/null || echo Unknown)"
    echo -e "${C}Uptime:${D} $(uptime -p 2>/dev/null || uptime 2>/dev/null || echo Unknown)"

    echo
    echo -e "${W}CPU${D}"
    if has nproc; then
        echo "Logical CPUs: $(nproc)"
    fi
    if [[ -r /proc/loadavg ]]; then
        echo "Load average: $(cat /proc/loadavg)"
    fi

    echo
    echo -e "${W}MEMORY${D}"
    if has free; then
        free -h
    else
        cat /proc/meminfo 2>/dev/null | head -n 5 || true
    fi

    echo
    echo -e "${W}DISK${D}"
    if has df; then
        df -h / 2>/dev/null || true
    fi

    echo
    echo -e "${W}NETWORK INTERFACES${D}"
    if has ip; then
        ip -brief address 2>/dev/null || true
    else
        warn "ip command is unavailable."
    fi

    pause
}

panel_info() {
    show_menu "SERVER PANEL MANAGER"

    if [[ -d /var/www/pterodactyl ]]; then
        ok "Pterodactyl directory detected: /var/www/pterodactyl"
    else
        warn "Default Pterodactyl directory not found."
    fi

    if has php; then
        echo "PHP: $(php -v 2>/dev/null | head -n 1)"
    else
        warn "PHP is not installed or is not in PATH."
    fi

    if has systemctl; then
        for service in nginx apache2 php8.3-fpm; do
            if systemctl list-unit-files "${service}.service" --no-legend 2>/dev/null |
                grep -q "${service}.service"; then
                printf "%-15s %s\n" "$service" \
                    "$(systemctl is-active "$service" 2>/dev/null || true)"
            fi
        done
    fi

    echo
    echo "Panel deployment shortcuts:"
    echo "  1) Pterodactyl"
    echo "  2) NovaStudio"
    echo "  3) JexPanel"
    echo "  4) Reviactyl"
    echo "  5) CtrlPanel"
    echo "  6) Paymenter"
    echo "  7) Convoy"
    echo "  8) FeatherPanel"
    echo "  9) Mythicaldash"
    echo " 10) Mythicaldash V3"
    echo " 11) VPS Panel"
    echo "  0) Exit"
    echo
    read -r -p "Select panel: " choice

    case "$choice" in
        1) info "Pterodactyl status is shown above."; pause ;;
        0) return ;;
        *) not_ready "Selected panel installer" ;;
    esac
}

wings_info() {
    show_menu "MACK CONTROL PANEL :: WINGS MANAGER"

    echo -e "${C}Operating System:${D} $(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-Unknown}" || echo Unknown)"
    echo -e "${C}RAM:${D}"
    if has free; then free -h; else warn "free command unavailable."; fi

    echo
    echo -e "${C}LAN interfaces:${D}"
    if has ip; then
        ip -brief address 2>/dev/null || true
    else
        warn "ip command unavailable."
    fi

    echo
    echo -e "${C}WAN:${D} Not checked (avoids an automatic external IP lookup)."

    echo
    if has systemctl; then
        echo -e "${W}Wings service:${D} $(systemctl is-active wings 2>/dev/null || echo unavailable)"
        echo -e "${W}Docker service:${D} $(systemctl is-active docker 2>/dev/null || echo unavailable)"
    else
        warn "systemctl unavailable; service status cannot be checked."
    fi

    echo
    echo "1) SSL Configuration (Certbot/Nginx)"
    echo "2) Install Wings"
    echo "3) Wings Manager"
    echo "4) Database Manager"
    echo "5) Uninstall Wings"
    echo "0) Back"
    echo
    read -r -p "Select option: " choice

    case "$choice" in
        1) not_ready "SSL configuration wizard" ;;
        2) not_ready "Wings installer; configure the official source first" ;;
        3)
            if has systemctl; then
                systemctl status wings --no-pager 2>/dev/null || true
            else
                warn "systemctl unavailable."
            fi
            pause
            ;;
        4) not_ready "Database manager" ;;
        5) warn "Uninstall is disabled to prevent accidental data loss."; pause ;;
        0) return ;;
        *) warn "Invalid option."; pause ;;
    esac
}

development_menu() {
    while true; do
        show_menu "DEVELOPMENT MENU"
        echo "1) RDX Tool"
        echo "2) Run VM 1 - KVM"
        echo "3) Run VM 2 - No KVM"
        echo "4) Run VM 3 - All Setup"
        echo "5) Back"
        echo
        read -r -p "Select Option: " choice

        case "$choice" in
            1) not_ready "RDX Tool" ;;
            2) not_ready "KVM virtual machine launcher" ;;
            3) not_ready "Non-KVM virtual machine launcher" ;;
            4) not_ready "Development VM setup" ;;
            5) return ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

toolbox_menu() {
    while true; do
        show_menu "TOOLBOX"

        echo -e "${W}ACCESS & NETWORK${D}"
        echo "1) Root / Sudo Status"
        echo "2) Tailscale Status"
        echo "3) ZeroTier Status"
        echo "4) Cloudflare Tunnel Status"
        echo
        echo -e "${W}SYSTEM${D}"
        echo "5) System Information"
        echo "6) Listening Ports"
        echo
        echo -e "${W}GUI & SSL${D}"
        echo "7) Web Terminal Status"
        echo "8) RDP Status"
        echo "9) SSL Certificate Status"
        echo "0) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            1)
                echo "Current user: $(id -un 2>/dev/null || echo Unknown)"
                if [[ ${EUID:-1} -eq 0 ]]; then
                    ok "Running as root."
                else
                    warn "Not running as root. Sudo: $(has sudo && echo installed || echo unavailable)"
                fi
                pause
                ;;
            2)
                if has tailscale; then
                    tailscale status 2>&1 || true
                else
                    warn "Tailscale is not installed."
                fi
                pause
                ;;
            3)
                if has zerotier-cli; then
                    zerotier-cli listnetworks 2>&1 || true
                else
                    warn "ZeroTier CLI is not installed."
                fi
                pause
                ;;
            4)
                if has cloudflared; then
                    cloudflared --version 2>&1 || true
                    if has systemctl; then
                        systemctl --no-pager --type=service 2>/dev/null |
                            grep -i cloudflared || true
                    fi
                else
                    warn "cloudflared is not installed."
                fi
                pause
                ;;
            5) system_info ;;
            6)
                if has ss; then
                    ss -tuln 2>/dev/null || true
                elif has netstat; then
                    netstat -tuln 2>/dev/null || true
                else
                    warn "Neither ss nor netstat is installed."
                fi
                pause
                ;;
            7)
                for app in ttyd wetty shellinabox; do
                    if has "$app"; then ok "$app is installed."; fi
                done
                warn "This check does not expose a terminal to the internet."
                pause
                ;;
            8)
                if has systemctl; then
                    systemctl status xrdp --no-pager 2>/dev/null || true
                else
                    warn "systemctl unavailable."
                fi
                pause
                ;;
            9)
                if has certbot; then
                    certbot certificates 2>&1 || true
                else
                    warn "Certbot is not installed."
                fi
                pause
                ;;
            0) return ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

blueprint_menu() {
    while true; do
        show_menu "CONTROL PANEL UI :: BLUEPRINT"

        if [[ -d /var/www/pterodactyl ]]; then
            echo -e "Pterodactyl: ${G}DETECTED${D}"
        else
            echo -e "Pterodactyl: ${Y}NOT DETECTED${D}"
        fi

        if has blueprint; then
            echo -e "Blueprint CLI: ${G}DETECTED${D}"
        else
            echo -e "Blueprint CLI: ${Y}NOT DETECTED${D}"
        fi

        echo
        echo "1) Blueprint"
        echo "2) Themes"
        echo "3) Extensions"
        echo "4) Hyper V1"
        echo "0) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            1)
                if has blueprint; then
                    blueprint --help 2>&1 || true
                else
                    echo "Official project: https://blueprint.zip/"
                    warn "Install Blueprint from its official documentation first."
                fi
                pause
                ;;
            2) themes_menu ;;
            3) extensions_menu ;;
            4) not_ready "Hyper V1 module" ;;
            0) return ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

themes_menu() {
    local themes=(
        nebula euphoriatheme BetterAdmin abysspurple amberabyss
        catppuccindactyl crimsonabyss emeraldabyss nightadmin
        refreshtheme slice darkenate recolor bluetables ultradarkadmin
        xlpaneltheme lememtheme slate kaelixprime m3dactyl
    )
    local i choice

    while true; do
        show_menu "BLUEPRINT THEMES"
        for i in "${!themes[@]}"; do
            printf "%2d) %s\n" "$((i + 1))" "${themes[$i]}"
        done
        echo " 0) Back"
        echo
        echo "Choose a theme to view its status; no package is installed automatically."
        read -r -p "Select theme: " choice

        [[ "$choice" == 0 ]] && return

        if [[ "$choice" =~ ^[0-9]+$ ]] &&
            (( choice >= 1 && choice <= ${#themes[@]} )); then
            info "Selected theme: ${themes[$((choice - 1))]}"
            not_ready "Verified installer for theme '${themes[$((choice - 1))]}'"
        else
            warn "Invalid option."
            pause
        fi
    done
}

extensions_menu() {
    local extensions=(
        adminauditlogs huxregister loader lyrdyannounce mclogs mcplugins
        mctools minecraftplayermanager playerlisting resourcealerts
        resourcemanager serverbackgrounds serversplitter simplefavicons
        snowflakes sociallogin startupchanger subdomains tawkto versionchanger
        pteromonaco urldownloader consolelogs laravellogs vanillatweaks
        modrinthbrowser nopagination activitypurges redirect simplefooters
        paneladdressoverride shownodeids votifiertester sidebar translations
        monacoeditor minecraftpluginmanager subdomainmanager serverimporter
        pstatistics pullfiles serverpropsmanager motdmaker servericonimporter
        sagaautosuspension sagaminecraftmodpackin blueannoucements trashbin
        eggchanger mysqlautobackup configeditor customserversort
        databaseimportexport minecraftmodmanager serverid stats vminfo customcss
        autobackups node mcp mcplayer pterodactylramburst pterodactylpanelban
        pterodactylcpuburst
    )
    local selected=()
    local choice i n

    while true; do
        show_menu "BLUEPRINT EXTENSIONS"
        echo "Total listed: ${#extensions[@]}"
        echo "Selected: ${#selected[@]}"
        echo

        for i in "${!extensions[@]}"; do
            printf "%2d) %s\n" "$((i + 1))" "${extensions[$i]}"
        done

        echo
        echo "i) Install selected (requires configured package sources)"
        echo "r) Remove selected (disabled until safe removal checks exist)"
        echo "a) Select all"
        echo "c) Clear selection"
        echo "0) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            i|I)
                if ((${#selected[@]} == 0)); then
                    warn "Select at least one extension by its number first."
                    pause
                else
                    warn "No verified package source is configured. Nothing installed."
                    printf 'Selected: %s\n' "${selected[*]}"
                    pause
                fi
                ;;
            r|R)
                warn "Removal is disabled to protect the live panel."
                pause
                ;;
            a|A)
                selected=()
                for ((n = 1; n <= ${#extensions[@]}; n++)); do
                    selected+=("$n")
                done
                ok "All extensions selected."
                ;;
            c|C)
                selected=()
                ok "Selection cleared."
                ;;
            0) return ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] &&
                    (( choice >= 1 && choice <= ${#extensions[@]} )); then
                    local found=0
                    for n in "${selected[@]}"; do
                        [[ "$n" == "$choice" ]] && found=1
                    done
                    if ((found)); then
                        warn "Already selected: ${extensions[$((choice - 1))]}"
                    else
                        selected+=("$choice")
                        ok "Selected: ${extensions[$((choice - 1))]}"
                    fi
                else
                    warn "Invalid option."
                fi
                pause
                ;;
        esac
    done
}

system_menu() {
    local items=(
        "System / Identity" "Hardware / Fingerprint" "SSH Controls"
        "Security" "Privacy" "Network" "Network Testing" "Performance"
        "Resource" "Users" "Monitoring" "Logs" "Cleanup" "Maintenance"
        "Panic" "Files" "Automation" "History" "Presets" "Menu"
        "Meta" "Report" "Smart VPS"
    )
    local choice

    while true; do
        show_menu "VPS EDIT PRO :: SYSTEM MENU"
        local i
        for i in "${!items[@]}"; do
            printf "%2d) %s\n" "$((i + 1))" "${items[$i]}"
        done
        echo " 0) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            0) return ;;
            1) system_info ;;
            2)
                echo "CPU: $(uname -m)"
                if has lscpu; then lscpu | head -n 15; fi
                pause
                ;;
            3)
                if has systemctl; then
                    systemctl status ssh --no-pager 2>/dev/null ||
                    systemctl status sshd --no-pager 2>/dev/null || true
                else
                    warn "systemctl unavailable."
                fi
                pause
                ;;
            6)
                if has ip; then ip route 2>/dev/null || true; ip -brief address 2>/dev/null || true; fi
                pause
                ;;
            7)
                if has ping; then
                    ping -c 3 -W 2 1.1.1.1 2>&1 || true
                else
                    warn "ping command unavailable."
                fi
                pause
                ;;
            8)
                if has uptime; then uptime; fi
                if has vmstat; then vmstat 1 2 2>/dev/null || true; fi
                pause
                ;;
            9)
                if has df; then df -h; fi
                if has free; then free -h; fi
                pause
                ;;
            10) if has who; then who; else warn "who command unavailable."; fi; pause ;;
            11)
                if has systemctl; then systemctl --failed --no-pager 2>/dev/null || true; fi
                pause
                ;;
            12)
                if has journalctl; then journalctl -n 40 --no-pager 2>/dev/null || true
                else warn "journalctl unavailable."; fi
                pause
                ;;
            13)
                warn "Automatic cleanup is disabled to avoid deleting important data."
                pause
                ;;
            14)
                if has systemctl; then systemctl --failed --no-pager 2>/dev/null || true; fi
                pause
                ;;
            22) system_info ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] &&
                    (( choice >= 1 && choice <= ${#items[@]} )); then
                    not_ready "System module '${items[$((choice - 1))]}'"
                else
                    warn "Invalid option."
                    pause
                fi
                ;;
        esac
    done
}

container_menu() {
    while true; do
        show_menu "NOBITA CONTROL CENTER :: CONTAINERS"

        if has docker; then
            echo "Docker CLI: installed"
            if docker info >/dev/null 2>&1; then
                ok "Docker daemon is responding."
            else
                warn "Docker daemon is unavailable or permission is denied."
            fi
        else
            warn "Docker CLI is not installed."
        fi

        echo
        echo "1) Cockpit Status"
        echo "2) SSH Web Access Status"
        echo "3) Kubernetes Status"
        echo "4) Windows VM 2016"
        echo "5) Tailscale Status"
        echo "6) Tocaltonet"
        echo "7) Proxmox Status"
        echo "8) Exit System"
        echo "0) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            1)
                if has systemctl; then systemctl status cockpit.socket --no-pager 2>/dev/null || true
                else warn "systemctl unavailable."; fi
                pause
                ;;
            2)
                if has systemctl; then systemctl status ssh --no-pager 2>/dev/null || true
                else warn "systemctl unavailable."; fi
                pause
                ;;
            3)
                if has kubectl; then kubectl version --client 2>&1 || true
                else warn "kubectl is not installed."; fi
                pause
                ;;
            4) not_ready "Windows VM 2016 launcher" ;;
            5)
                if has tailscale; then tailscale status 2>&1 || true
                else warn "Tailscale is not installed."; fi
                pause
                ;;
            6) not_ready "Tocaltonet module" ;;
            7)
                if has pvesh; then pvesh get /cluster/status 2>&1 || true
                else warn "Proxmox tools not detected on this system."; fi
                pause
                ;;
            8) return ;;
            0) return ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

new_module_menu() {
    while true; do
        show_menu "NEW MODULE MANAGER"
        echo "Module directory: ./modules/"
        echo

        if [[ -d ./modules ]]; then
            find ./modules -maxdepth 1 -type f -name '*.sh' -printf '%f\n' 2>/dev/null ||
                echo "No module files found."
        else
            echo "No modules directory exists yet."
        fi

        echo
        echo "1) Show module folder instructions"
        echo "2) Create modules directory"
        echo "0) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            1)
                echo "Place reviewed module scripts in ./modules/."
                echo "Review a script before running it."
                echo "Modules are not automatically executed by this menu."
                pause
                ;;
            2)
                if mkdir -p ./modules; then ok "Created ./modules/"
                else warn "Could not create module directory."; fi
                pause
                ;;
            0) return ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

infra_menu() {
    while true; do
        show_menu "VAMPIRE STUDIO :: INFRASTRUCTURE"
        echo "1) Cockpit"
        echo "2) CasaOS"
        echo "3) 1Panel"
        echo "4) LXC / LXD"
        echo "5) Docker"
        echo "6) vpanel"
        echo "7) Back"
        echo
        read -r -p "Select option: " choice

        case "$choice" in
            1)
                if has systemctl; then systemctl status cockpit.socket --no-pager 2>/dev/null || true
                else warn "systemctl unavailable."; fi
                pause
                ;;
            2) not_ready "CasaOS installer" ;;
            3) not_ready "1Panel installer" ;;
            4)
                if has lxc; then lxc list 2>&1 || true
                elif has lxc-ls; then lxc-ls 2>&1 || true
                else warn "LXC tools are not installed."; fi
                pause
                ;;
            5)
                if has docker; then
                    docker --version
                    docker ps -a 2>&1 || warn "Docker daemon unavailable or access denied."
                else
                    warn "Docker is not installed."
                fi
                pause
                ;;
            6) not_ready "vpanel installer" ;;
            7|0) return ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

main_menu() {
    while true; do
        header
        echo -e "${W}MAIN MENU${D}"
        line
        echo " [1] VPS / System Info"
        echo " [2] Panel Manager"
        echo " [3] Wings Manager"
        echo " [4] Toolbox"
        echo " [5] Blueprint / Themes / Extensions"
        echo " [6] System Menu"
        echo " [7] Container Manager"
        echo " [8] Development / New Modules"
        echo " [9] Infrastructure / Extras"
        echo " [0] Exit"
        line
        read -r -p "Vampire Studio > " choice

        case "$choice" in
            1) system_info ;;
            2) panel_info ;;
            3) wings_info ;;
            4) toolbox_menu ;;
            5) blueprint_menu ;;
            6) system_menu ;;
            7) container_menu ;;
            8)
                while true; do
                    show_menu "DEVELOPMENT & MODULES"
                    echo "1) Development Menu"
                    echo "2) New Module Manager"
                    echo "0) Back"
                    echo
                    read -r -p "Select option: " sub
                    case "$sub" in
                        1) development_menu ;;
                        2) new_module_menu ;;
                        0) break ;;
                        *) warn "Invalid option."; pause ;;
                    esac
                done
                ;;
            9) infra_menu ;;
            0)
                echo -e "${R}Vampire Studio closed. Goodbye!${D}"
                exit 0
                ;;
            *) warn "Invalid option."; pause ;;
        esac
    done
}

main_menu
