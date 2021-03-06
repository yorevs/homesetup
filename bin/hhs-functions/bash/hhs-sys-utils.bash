#!/usr/bin/env bash

#  Script: hhs-sys-utils.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Display relevant system information.
function __hhs_sysinfo() {

  local username containers

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} "
    return 1
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
    echo -e "  Hostname..... : $(hostname)"
    if __hhs_has __hhs_ip; then
      ip_gw=$(__hhs_ip gateway | awk '{print $2}')
      ip_local=$(__hhs_ip local | awk '{print $2}' | tr '\n' ' ')
      ip_ext=$(__hhs_ip external | awk '{print $2}')
      ip_vpn=$(__hhs_ip vpn | awk '{print $2}')
      echo -e "  Gateway...... : ${ip_gw:-${YELLOW}Unavailable${HHS_HIGHLIGHT_COLOR}}"
      echo -e "  IP-Local......: ${ip_local:-${YELLOW}Unavailable${HHS_HIGHLIGHT_COLOR}}"
      echo -e "  IP-External.. : ${ip_ext:-${YELLOW}Not connected to the internet${HHS_HIGHLIGHT_COLOR}}"
      echo -e "  IP-VPN(tun).. : ${ip_vpn:-${YELLOW}Not connected to VPN${HHS_HIGHLIGHT_COLOR}}"
    fi
    echo -e "\n${GREEN}Logged Users:${HHS_HIGHLIGHT_COLOR}"

    IFS=$'\n'
    for next in $(who); do
      echo -e "  ${next}"
    done

    if __hhs_has "docker" && __hhs_has "__hhs_docker_ps"; then
      containers=$(__hhs_docker_ps -a)
      if [[ -n "${containers}" && $(__hhs_docker_count) -gt 1 ]]; then
        echo -e "\n${GREEN}Active Docker Containers: ${BLUE}"
        for next in ${containers}; do
          echo "${next}" | esed -e "s/(^CONTAINER.*)/${WHITE}\1${BLUE}/" -e 's/^/  /'
        done
      fi
    fi

    echo "${NC}"
    IFS=${RESET_IFS}
  fi

  return 0
}

# @function: Display a process list matching the process name/expression.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function __hhs_process_list() {

  local all_pids uid pid ppid cmd force quiet pad gflags='-E'

  if [[ "$#" -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <process_name> [kill]"
    echo ''
    echo '    Options: '
    echo '        -i : Make case insensitive search'
    echo '        -w : Match full words only'
    echo '        -f : Do not ask questions when killing processes'
    echo '        -q : Be less verbose as possible'
    echo ''
    echo '  Notes: '
    echo '    kill : If specified, it will kill the process it finds'
    return 1
  else
    while [[ -n "$1" ]]; do
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
          [[ ! "$1" =~ ^-[wifq] ]] && break
          ;;
      esac
      shift
    done
    [[ "${HHS_MY_OS}" == "Linux" ]]
    # shellcheck disable=SC2009,SC2086
    [[ -n "$1" ]] && all_pids=$(ps -axco uid,pid,ppid,comm | grep ${gflags} "$1")
    if [[ -n "${all_pids}" ]]; then
      pad="$(printf '%0.1s' " "{1..40})"
      divider="$(printf '%0.1s' "-"{1..92})"
      echo ''
      [[ -z "$quiet" ]] && printf "${WHITE}%5s\t%5s\t%5s\t%-40s %s\n" "UID" "PID" "PPID" "COMMAND" "ACTIVE ?"
      [[ -z "$quiet" ]] && printf "%-154s\n\n" "$divider"
      IFS=$'\n'
      for next in ${all_pids}; do
        uid=$(awk '{ print $1 }' <<< "${next}")
        pid=$(awk '{ print $2 }' <<< "${next}")
        ppid=$(awk '{ print $3 }' <<< "${next}")
        cmd=$(awk '{for(i=4;i<=NF;i++) printf $i" "; print ""}' <<< "${next}")
        [[ "${#cmd}" -ge 37 ]] && cmd="${cmd:0:37}..."
        printf "${HHS_HIGHLIGHT_COLOR}%5s\t%5s\t%5s\t%s" "${uid}" "${pid}" "${ppid}" "${cmd}"
        printf '%*.*s' 0 $((40 - ${#cmd})) "${pad}"
        if [[ -n "${pid}" && "$2" == "kill" ]]; then
          save-cursor-pos
          if [[ -z "${force}" ]]; then
            read -r -n 1 -p "${ORANGE} Kill this process y/[n]? " ANS
          fi
          if [[ -n "${force}" || "$ANS" == "y" || "$ANS" == "Y" ]]; then
            restore-cursor-pos
            if kill -9 "${pid}" &> /dev/null; then 
              echo -en "${GREEN}=> Killed \"${pid}\" with SIGKILL(-9)\033[K"
            else
              echo -en "${ORANGE}=> Skipped \"${pid}\" (INACTIVE)\033[K"
            fi
          fi
          if [[ -n "$ANS" || -n "${force}" ]]; then echo -e "${NC}"; fi
        else
          # Check for ghost processes
          if ps -p "${pid}" &> /dev/null; then
            echo -e "${GREEN} ${CHECK_ICN}  active process"
          else
            echo -e "${RED} ${CROSS_ICN}  ghost process"
          fi
        fi
      done
      IFS="${RESET_IFS}"
    else
      echo -e "\n${YELLOW}No active PIDs for process named: \"$1\""
    fi
  fi

  echo -e "${NC}"

  return 0
}

# @function: Kills ALL processes specified by name
# @param $1 [Req] : The process name to kill
function __hhs_process_kill() {

  local ret_val=1 force_flag=
  
  if [[ "$#" -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <process_name>"
    echo ''
    echo '    Options: '
    echo '        -f | --force : Do not prompt for confirmation when killing a process'
    return 1
  fi
  
  if [[ "$1" == "-f" || "$1" == "--force" ]]; then
    shift
    force_flag='-f'
  fi

  for nproc in "${@}"; do
    __hhs_process_list -q ${force_flag} "${nproc}" kill
    ret_val=$?
    echo -e "\033[3A" # Move up 3 lines to beautify the output
  done
  echo -e '\n'

  return ${ret_val}
}

# @function: Exhibit a Human readable summary about all partitions.
function __hhs_partitions() {

  local all_parts str_text mounted size used avail cap

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} "
    return 1
  else
    all_parts="$(df -H | tail -n +2)"
    (
      IFS=$'\n'
      echo "${WHITE}"
      printf '%-4s\t%-5s\t%-4s\t%-8s\t%-s\n' 'Size' 'Avail' 'Used' 'Capacity' 'Mounted-ON'   
      echo -e "----------------------------------------------------------------${HHS_HIGHLIGHT_COLOR}"
      for next in $all_parts; do
        str_text=${next:16}
        size="$(awk '{ print $1 }' <<< "${str_text}")"
        avail="$(awk '{ print $3 }' <<< "${str_text}")"
        used="$(awk '{ print $2 }' <<< "${str_text}")"
        cap="$(awk '{ print $4 }' <<< "${str_text}")"
        [[ "Darwin" == "${HHS_MY_OS}" ]] && mounted="$(awk '{ print $8 }' <<< "${str_text}")"
        [[ "Linux" == "${HHS_MY_OS}" ]] && mounted="$(awk '{ print $5 }' <<< "${str_text}")"
        printf '%-4s\t%-5s\t%-4s\t%-8s\t%-s\n' "${size:0:4}" "${avail:0:4}" "${used:0:4}" "${cap:0:4}" "${mounted:0:40}"
      done
      echo "${NC}"
    )
  fi

  return 0
}
