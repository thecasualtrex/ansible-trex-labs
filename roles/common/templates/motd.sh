#!/bin/bash

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
WHITE="\e[97m"
RESET="\e[0m"

# Variables
HOSTNAME=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
LOAD=$(cat /proc/loadavg | awk '{print $1 " " $2 " " $3}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')
IP=$(hostname -I | awk '{print $1}')
USERS=$(who | wc -l)
DATE=$(date "+%A, %d %B %Y - %H:%M:%S")

clear

echo -e "${GREEN}Hostname:${RESET}    $HOSTNAME"
echo -e "${GREEN}System:${RESET}      $OS"
echo -e "${GREEN}Kernel:${RESET}      $KERNEL"
echo -e "${GREEN}Uptime:${RESET}      $UPTIME"
echo -e "${GREEN}Load Avg:${RESET}    $LOAD"

echo ""
echo -e "${YELLOW}Memory:${RESET}      ${MEM_USED} MiB used / ${MEM_TOTAL} MiB total (${MEM_AVAILABLE} MiB available)"
echo -e "${YELLOW}Disk (/):${RESET} $DISK_USAGE"

echo ""
echo -e "${BLUE}IP Address:${RESET}  $IP"
echo -e "${BLUE}Users Logged In:${RESET} $USERS"

echo ""
echo -e "${WHITE}$DATE${RESET}"
