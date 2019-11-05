#!/usr/bin/env bash

#  Script: hhs-sysinfo.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Retrieve relevant system information.
function __hhs_sysinfo() {
    
    local username
    local containers
    username="$(whoami)"

    echo -e "\n${ORANGE}System information ------------------------------------------------"
    echo -e "\n${GREEN}User:${HIGHLIGHT_COLOR}"
    echo -e "  Username..... : $username"
    echo -e "  UID.......... : $(id -u "$username")"
    echo -e "  GID.......... : $(id -g "$username")"
    echo -e "\n${GREEN}System:${HIGHLIGHT_COLOR}"
    echo -e "  OS........... : ${MY_OS}"
    echo -e "  Kernel........: v$(uname -pmr)"
    echo -e "  Up-Time...... : $(uptime | cut -c 1-15)"
    echo -e "  MEM Usage.... : ~$(ps -A -o %mem | awk '{s+=$1} END {print s "%"}')"
    echo -e "  CPU Usage.... : ~$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')"
    echo -e "\n${GREEN}Storage:"
    printf "${WHITE}  %-15s %-7s %-7s %-7s %-5s \n" "Disk" "Size" "Used" "Free" "Cap"
    echo -e "${HIGHLIGHT_COLOR}$(df -h | grep "^/dev/disk\|^.*fs" | awk -F " *" '{ printf("  %-15s %-7s %-7s %-7s %-5s \n", $1,$2,$3,$4,$5) }')"
    echo -e "\n${GREEN}Network:${HIGHLIGHT_COLOR}"
    echo -e "  Hostname..... : $(hostname)"
    echo -e "  Gateway...... : $(route get default  | grep gateway | cut -b 14-)"
    has "pcregrep" && echo -e "$(ipl | awk '{ printf("  %s\n", $0) }')"
    has "dig" && echo -e "  Real-IP...... : $(ip)"
    echo -e "\n${GREEN}Logged Users:${HIGHLIGHT_COLOR}"
    ( 
        IFS=$'\n'
        for next in $(who)
        do 
            echo -e "  $next"
        done 
        IFS=$RESET_IFS
    )

    if has "docker"; then
        containers=$(__hhs_docker_ps)
        if [ -n "$containers" ]; then
            echo -e "\n${GREEN}Docker Containers: ${BLUE}"
            ( 
                IFS=$'\n'
                for next in ${containers}
                do 
                    echo -e "  $next"
                done 
                IFS=$RESET_IFS
            )
        fi
    fi
    echo -e "${NC}"

    return 0
}