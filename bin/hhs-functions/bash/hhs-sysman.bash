#!/usr/bin/env bash

#  Script: hhs-sysman.bash
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
    echo -e "\n${GREEN}User:${HHS_HIGHLIGHT_COLOR}"
    echo -e "  Username..... : $username"
    echo -e "  UID.......... : $(id -u "$username")"
    echo -e "  GID.......... : $(id -g "$username")"
    echo -e "\n${GREEN}System:${HHS_HIGHLIGHT_COLOR}"
    echo -e "  OS........... : ${HHS_MY_OS} $(uname -pmr)"
    __hhs_has "sw_vers" && echo -e "  Software......: $(sw_vers | awk '{print $2" "$3}' | tr '\n' ' ')"
    echo -e "  Up-Time...... : $(uptime | cut -c 1-15)"
    echo -e "  MEM Usage.... : ~$(ps -A -o %mem | awk '{s+=$1} END {print s "%"}')"
    echo -e "  CPU Usage.... : ~$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')"
    echo -e "\n${GREEN}Storage:"
    printf "${WHITE}  %-15s %-7s %-7s %-7s %-5s \n" "Disk" "Size" "Used" "Free" "Cap"
    echo -e "${HHS_HIGHLIGHT_COLOR}$(df -h | grep "^/dev/disk\|^.*fs" | awk -F " *" '{ printf("  %-15s %-7s %-7s %-7s %-5s \n", $1,$2,$3,$4,$5) }')"
    echo -e "\n${GREEN}Network:${HHS_HIGHLIGHT_COLOR}"
    echo -e "  Hostname..... : $(hostname || echo "${RED}Not connected to the internet${HHS_HIGHLIGHT_COLOR}")"
    echo -e "  Gateway...... : $(__hhs_gateway_ip || echo "${RED}Not connected to the internet${HHS_HIGHLIGHT_COLOR}")"
    if __hhs_has "ifconfig"; then
      echo -e "$(ipl | sed 's/^/  /g')" # Get local IPs
      echo -e "  IP-External.. : $(my-ip || echo "${RED}Not connected to the internet${HHS_HIGHLIGHT_COLOR}")"
      echo -e "  IP-VPN(tun).. : $(vpn-ip || echo "${YELLOW}Not connected${HHS_HIGHLIGHT_COLOR}")"
    fi
    echo -e "\n${GREEN}Logged Users:${HHS_HIGHLIGHT_COLOR}"

    IFS=$'\n'
    for next in $(who); do
      echo -e "  ${next}"
    done

    if __hhs_has "docker"; then
      containers=$(__hhs_docker_ps -a)
      if [ -n "${containers}" ] && [[ $(__hhs_docker_count) -gt 1 ]]; then
        echo -e "\n${GREEN}Active Docker Containers: ${BLUE}"
        for next in ${containers}; do
          echo "$next" | esed -e "s/(^CONTAINER.*)/${WHITE}\1${BLUE}/" -e 's/^/  /'
        done
      fi
    fi

    echo "${NC}"
    IFS=$HHS_RESET_IFS
  fi

  return 0
}

# @function: Display a process list matching the process name/expression.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function __hhs_process_list() {

  local all_pids uid pid ppid cmd force quiet pad gflags='-E'

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} [-i,-w,-f] <process_name> [kill]"
    echo ''
    echo 'Options: '
    echo '    -i : Make case insensitive search'
    echo '    -w : Match full words only'
    echo '    -f : Do not ask questions when killing processes'
    echo '    -q : Be less verbose as possible'
    return 1
  else
    while [ -n "$1" ]; do
      case "$1" in
        -w | --words)
          gflags="${gflags//E/Fw}"
          ;;
        -i | --ignore-case)
          gflags="${gflags}i"
          ;;
        -f | --force)
          force=1
          ;;
        -q | --quiet)
          quiet=1
          ;;
        *)
          [[ ! "$1" =~ ^-[wi] ]] && break
          ;;
      esac
      shift
    done
    # shellcheck disable=SC2009
    all_pids=$(ps -efc | grep ${gflags} "$1" | awk '{ print $1,$2,$3,$8 }')
    if [ -n "$all_pids" ]; then
      pad="$(printf '%0.1s' " "{1..40})"
      divider="$(printf '%0.1s' "-"{1..92})"
      echo ''
      [ -z "$quiet" ] && printf "${WHITE}%4s\t%5s\t%5s\t%-40s %s\n" "UID" "PID" "PPID" "COMMAND" "ACTIVE ?"
      [ -z "$quiet" ] && printf "%-154s\n\n" "$divider"
      IFS=$'\n'
      for next in $all_pids; do
        uid=$(echo "$next" | awk '{ print $1 }')
        pid=$(echo "$next" | awk '{ print $2 }')
        ppid=$(echo "$next" | awk '{ print $3 }')
        cmd=$(echo "$next" | awk '{ print $4 }')
        [ "${#cmd}" -ge 37 ] && cmd="${cmd:0:37}..."
        printf "${HHS_HIGHLIGHT_COLOR}%4d\t%5d\t%5d\t%s" "$uid" "$pid" "$ppid" "${cmd}"
        printf '%*.*s' 0 $((40 - ${#cmd})) "$pad"
        if [ -n "$pid" ] && [ "$2" = "kill" ]; then
          save-cursor-pos
          if [ -z "${force}" ]; then
            read -r -n 1 -p "${ORANGE} Kill this process y/[n]? " ANS
          fi
          if [ -n "${force}" ] || [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
            restore-cursor-pos
            kill -9 "$pid" && echo -en "${RED}=> Killed with SIGKILL(-9)\033[K"
          fi
          if [ -n "$ANS" ] || [ -n "${force}" ]; then echo -e "${NC}"; fi
        else
          # Check for ghost processes
          if ps -p "$pid" &> /dev/null; then
            echo -e "${GREEN} ${CHECK_ICN}  active"
          else
            echo -e "${RED} ${CROSS_ICN}  ghost"
          fi
        fi
      done
      IFS="$HHS_RESET_IFS"
    else
      echo -e "\n${YELLOW}No active PIDs for process named: \"$1\""
    fi
  fi

  echo -e "${NC}"

  return 0
}

# @function: Exhibit a Human readable summary about all partitions.
function __hhs_partitions() {

  local all_parts str_text mounted size used avail cap

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} "
  else
    all_parts="$(df -Ha | tail -n +2)"
    (
      IFS=$'\n'
      echo "${WHITE}"
      printf '%-25s\t%-4s\t%-4s\t%-4s\t%-4s\t\n' 'Mounted-ON' 'Size' 'Used' 'Avail' 'Capacity'
      echo -e "----------------------------------------------------------------${HHS_HIGHLIGHT_COLOR}"
      for next in $all_parts; do
        str_text=${next:16}
        mounted="$(echo "$str_text" | awk '{ print $8 }')"
        size="$(echo "$str_text" | awk '{ print $1 }')"
        used="$(echo "$str_text" | awk '{ print $2 }')"
        avail="$(echo "$str_text" | awk '{ print $3 }')"
        cap="$(echo "$str_text" | awk '{ print $4 }')"
        printf '%-25s\t' "${mounted:0:25}"
        printf '%4s\t' "${size:0:4}"
        printf '%4s\t' "${used:0:4}"
        printf '%4s\t' "${avail:0:4}"
        printf '%4s\n' "${cap:0:4}"
      done
      echo "${NC}"
    )
  fi

  return 0
}
