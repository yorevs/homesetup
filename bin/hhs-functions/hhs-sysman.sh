#!/usr/bin/env bash

#  Script: hhs-sysman.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Display a process list matching the process name/expression.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function __hhs_process_list() {

    local allPids
    local pid
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
                IFS="$RESET_IFS"
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

    local allParts
    local strText
    local mounted
    local size
    local used
    local avail
    local cap

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

    return 0
}