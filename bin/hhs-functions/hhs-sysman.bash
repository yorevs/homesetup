#!/usr/bin/env bash

#  Script: hhs-sysman.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Retrieve relevant system information.
function __hhs_sysinfo() {
    
    local username containers

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ${FUNCNAME[0]} "
    else
        username="$(whoami)"
        echo -e "\n${ORANGE}System information ------------------------------------------------"
        echo -e "\n${GREEN}User:${HIGHLIGHT_COLOR}"
        echo -e "  Username..... : $username"
        echo -e "  UID.......... : $(id -u "$username")"
        echo -e "  GID.......... : $(id -g "$username")"
        echo -e "\n${GREEN}System:${HIGHLIGHT_COLOR}"
        echo -e "  OS........... : ${HHS_MY_OS}"
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
                echo -e "  ${next}"
            done 
            IFS=$HHS_RESET_IFS
        )
        if has "docker"; then
            containers=$(__hhs_docker_ps)
            if [ -n "${containers}" ]; then
                echo -e "\n${GREEN}Docker Containers: ${BLUE}"
                ( 
                    IFS=$'\n'
                    for next in ${containers}
                    do 
                        echo -e "  ${next}"
                    done 
                    IFS=$HHS_RESET_IFS
                )
            fi
        fi
        echo -e "${NC}"
    fi

    return 0
}

# @function: Display a process list matching the process name/expression.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function __hhs_process_list() {

    local allPids pid
    local gflags='-E'

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 1 ]; then
        echo "Usage: ${FUNCNAME[0]} [-i,-w] <process_name> [kill]"
        echo ''
        echo 'Options: '
        echo '    -i : Make case insensitive search'
        echo '    -w : Match full words only'
        return 1
    else
        while [ -n "$1" ]
        do
            case "$1" in
                -w | --words)
                    gflags="${gflags//E/Fw}"
                ;;
                -i | --ignore-case)
                    gflags="${gflags}i"
                ;;
                *)
                    [[ ! "$1" =~ ^-[wi] ]] && break
                ;;
            esac
            shift
        done
        # shellcheck disable=SC2009,SC2086
        allPids=$(ps -efc | grep ${gflags} "$1" | awk '{ print $1,$2,$3,$8 }')
        if [ -n "$allPids" ]; then
            echo -e "${WHITE}\nUID\tPID\tPPID\tCOMMAND"
            echo '--------------------------------------------------------------------------------'
            echo -e "${RED}"
            (
                IFS=$'\n'
                for next in $allPids; do
                    pid=$(echo "$next" | awk '{ print $2 }')
                    echo -en "${HIGHLIGHT_COLOR}$next" | tr ' ' '\t'
                    if [ -n "$pid" ] && [ "$2" = "kill" ]; then 
                        kill -9 "$pid"
                        echo -e "${RED}\t\t\t\t=> Killed with signal -9"
                    else
                        ps -p "$pid" &>/dev/null && echo -e "${GREEN}**" || echo -e "${RED}**"
                    fi
                done
                IFS="$HHS_RESET_IFS"
            )
        else
            echo -e "\n${YELLOW}No active PIDs for process named: \"$1\""
        fi
    fi

    echo -e "${NC}"

    return 0
}

# @function: Exhibit a Human readable summary about all partitions.
function __hhs_partitions() {

    local allParts strText mounted size used avail cap

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ${FUNCNAME[0]} "
    else
        allParts="$(df -Ha | tail -n +2)"
        (
            IFS=$'\n'
            echo "${WHITE}"
            printf '%-25s\t%-4s\t%-4s\t%-4s\t%-4s\t\n' 'Mounted-ON' 'Size' 'Used' 'Avail' 'Capacity'
            echo -e "----------------------------------------------------------------${HIGHLIGHT_COLOR}"
            for next in $allParts
            do
                strText=${next:16}
                mounted="$(echo "$strText" | awk '{ print $8 }')"
                size="$(echo "$strText" | awk '{ print $1 }')"
                used="$(echo "$strText" | awk '{ print $2 }')"
                avail="$(echo "$strText" | awk '{ print $3 }')"
                cap="$(echo "$strText" | awk '{ print $4 }')"
                printf '%-25s\t' "${mounted:0:25}"
                printf '%4s\t'  "${size:0:4}"
                printf '%4s\t'  "${used:0:4}"
                printf '%4s\t'  "${avail:0:4}"
                printf '%4s\n'  "${cap:0:4}"
            done
            echo "${NC}"
        )
    fi

    return 0
}

function __hhs_select-shell() {

    local selIndex selShell mselectFile results=()

    clear
    echo "${YELLOW}@@ Please select your new default shell:"
    echo "-------------------------------------------------------------"
    echo -en "${NC}"
    IFS=$'\n' read -d '' -r -a results <<< "$(grep '/.*' '/etc/shells')"
    mselectFile=$(mktemp)
    __hhs_mselect "$mselectFile" "${results[*]}"
    # shellcheck disable=SC2181
    if [ "$?" -eq 0 ]; then
        selIndex=$(grep . "$mselectFile")
        selShell=${results[$selIndex]}
        if [ -n "$selShell" ] && [ -f "$selShell" ]; then
            chsh -s "$selShell"
            export SHELL="$selShell"
            if [ $? -eq 0 ]; then
                clear
                echo "${ORANGE}Your default shell has changed to => ${GREEN}'$SHELL'"
                echo "${ORANGE}Next time you open a terminal window you will use the new shell"
            fi
        fi
    fi
    IFS="$HHS_RESET_IFS"
    echo -e "${NC}"

    # Find all dotfiles
    # find . -maxdepth 1 -type l -name ".bash*"

    return 0
}