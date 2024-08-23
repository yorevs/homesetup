#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains all HHS-App built-in functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# @purpose: List all HHS App Plug-ins and Functions.
# @param $1 [opt] : Instead of a formatted as a list, flat the commands for bash completion.
function list() {

  local args=("${@}")

  if [[ "$1" == "help" ]]; then
    echo "Usage: __hhs ${FUNCNAME[0]} [-flat] [-plugins] [-funcs]" && quit 0
  elif [[ "${args[*]}" =~ -flat ]]; then
    args=("${args[@]/'-flat'/}")
    [[ ${#args[@]} -eq 1 || "${args[*]}" =~ -plugins ]] \
      && for next in "${PLUGINS[@]}"; do echo -n "${next} "; done
    [[ ${#args[@]} -eq 1 || "${args[*]}" =~ -funcs ]] \
      && for next in "${HHS_APP_FUNCTIONS[@]}"; do echo -n "${next} "; done
    quit 0 ''
  else
    columns="$(tput cols)"
    count=$((${#PLUGINS[@]} > ${#HHS_APP_FUNCTIONS[@]} ? ${#PLUGINS[@]} : ${#HHS_APP_FUNCTIONS[@]}))
    echo -e "\n${YELLOW}HomeSetup application commands"
    if [[ ${#args[@]} -eq 0 || "${args[*]}" =~ -plugins ]]; then
      echo -e "\n${ORANGE}-=- HHS Plug-ins -=-\n"
      for idx in "${!PLUGINS[@]}"; do
        line="${PLUGINS[$idx]}"
        printf "${YELLOW}%${#count}d  ${HHS_HIGHLIGHT_COLOR}" "$((idx + 1))"
        echo -en "${line:0:${columns}}${NC}"
        [[ "${#line}" -ge "${columns}" ]] && echo -n "..."
        echo -e "${NC}"
      done
    fi
    if [[ ${#args[@]} -eq 0 || "${args[*]}" =~ -funcs ]]; then
      echo -e "\n${ORANGE}-=- HHS Functions -=-\n"
      for idx in "${!HHS_APP_FUNCTIONS[@]}"; do
        line="${HHS_APP_FUNCTIONS[$idx]}"
        printf "${YELLOW}%${#count}d  ${HHS_HIGHLIGHT_COLOR}" "$((idx + 1))"
        echo -en "${line:0:${columns}}${NC}"
        [[ "${#line}" -ge "${columns}" ]] && echo -n "..."
        echo -e "${NC}"
      done
    fi
  fi

  quit 0 ''
}

# @purpose: Search for all __hhs_functions describing it's containing file name and line number.
function funcs() {

  local idx columns fn_name cache_file usage filter count matches=0

  usage="Usage: __hhs ${FUNCNAME[0]} [regex_filter]"

  [[ "$1" == 'help' ]] && echo "${usage}" && quit 0

  cache_file="${HHS_CACHE_DIR}/hhs-funcs-${HHS_VERSION//./}.cache"

  filter=$*
  filter="${filter// /\|}"
  filter="${filter:-.*}"

  echo ' '
  echo "${YELLOW}-=- Available HomeSetup v${HHS_VERSION} functions matching [${filter}] -=-"

  if [[ ! -s "${cache_file}" ]]; then
    echo -en "${ORNGE}Please wait until we cache all HomeSetup v${HHS_VERSION} functions ...${NC}"
    search_hhs_functions "${HHS_HOME}/dotfiles/bash" "${HHS_HOME}/bin/hhs-functions/bash" "${HHS_HOME}/bin/dev-tools/bash"
    printf "%s\n" "${HHS_FUNCTIONS[@]}" > "${cache_file}"
    echo -en '\033[2K'
    echo ''
  else
    echo ' '
    IFS=$'\n' read -r -d '' -a HHS_FUNCTIONS < <(grep . "${cache_file}")
    IFS="${OLDIFS}"
  fi

  columns="$(tput cols)"
  count="${#HHS_FUNCTIONS[@]}"
  for line in "${HHS_FUNCTIONS[@]}"; do
    fn_name=$(awk 'BEGIN { FS = "=>" } ; { print $2 }' <<< "${line}")
    fn_name=${fn_name%%:*}
    fn_name=$(trim <<< "${fn_name}")
    if [[ ${fn_name} =~ ${filter} ]]; then
      ((matches++))
      printf "${YELLOW}%${#count}d  ${HHS_HIGHLIGHT_COLOR}" "$((matches))"
      echo -en "${line:0:${columns}}${NC}"
      [[ "${#line}" -ge "${columns}" ]] && echo -n "..."
      echo -e "${NC}"
    fi
  done

  [[ $matches -eq 0 ]] && echo -e "${YELLOW}No functions found matching \"${filter}\"${NC}"

  quit 0
}

# @purpose: Retrieve HomeSetup logs.
# @param $1 [opt] : The hhs file to retrieve logs from.
# @param $2 [opt] : The log level to retrieve.
function logs() {

  local level logfile logs usage tail_opts="-n ${HHS_LOG_LINES:-100}"
  local all_levels="ALL CRITICAL DEBUG ERROR FATAL FINE INFO OUT TRACE WARNING WARN SEVERE"

  usage="Usage: __hhs ${FUNCNAME[0]} [-F] [hhs-log-file] [level]"

  [[ "${1}" = '-F' ]] && tail_opts="${tail_opts} -F" && shift
  [[ "${1}" =~ -h|--help ]] && quit 0 "${usage}"
  level=$(echo "${1}" | tr '[:lower:]' '[:upper:]')

  if [[ -n "${level}" ]]; then
    if ! list_contains "${all_levels}" "${level}"; then
      logfile="${HHS_LOG_DIR}/${1//.log/}.log"
      if [[ ! -f "${logfile}" ]]; then
        logs=$(find "${HHS_LOG_DIR}" -type f -name '*.log' -exec basename {} \;)
        echo -e "${RED}## Log file not found: ${logfile}."
        echo -e "${ORANGE}\nAvailable log files: \n\n${logs}\n"
        quit 1
      fi
      level=$(echo "${2}" | tr '[:lower:]' '[:upper:]')
      if [[ -n "${level}" ]]; then
        if ! list_contains "${all_levels}" "${level}"; then
          quit 1 "Undefined log level: ${level}"
        fi
      fi
    else
      [[ -n $2 ]] && logfile="${HHS_LOG_DIR}/${2//.log/}.log"
      if [[ -n "${logfile}" && ! -f "${logfile}" ]]; then
        logs=$(find "${HHS_LOG_DIR}" -type f -name '*.log' -exec basename {} \;)
        echo -e "${RED}## Log file not found: ${logfile}."
        echo -e "${ORANGE}\nAvailable log files: \n\n${logs}\n"
        quit 1
      fi
    fi
  fi

  logfile=${logfile:="${HHS_LOG_FILE}"}
  re='-n [0-9]* -F'

  [[ ${tail_opts} =~ ${re} ]] && echo -en "\n${WHITE}Tailing " || echo -en "\n${WHITE}Retrieving "
  echo -e "[${level:-ALL}] logs from ${logfile} (last ${HHS_LOG_LINES:-100} lines):${NC}\n"

  if [[ -z "${level}" || "${level}" == 'ALL' ]]; then
    __hhs_tailor "${tail_opts}" "${logfile}"
  else
    __hhs_tailor "${tail_opts}" "${logfile}" | grep -i "${level}"
  fi

  quit $?
}

# @purpose: Display logs for a specified process over the last specified number of days.
# @param $1 [req] : The name of the process to filter logs for.
# @param $2 [req] : The number of days in the past to search for logs.
function sys-logs() {
    local process_name=$1 days=$2
    # Check if both arguments are provided
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: __hhs ${FUNCNAME[0]} <process_name> <days>"
        return 1
    fi
    shift 2
    log show --predicate "process == \"${process_name}\"" --info --last "${days}"d "$@"
}


# @purpose: Fetch the ss64 manual from the web for the specified bash command.
# @param $1 [req] : The bash command to find out the manual.
function man() {

  local ss63_url="https://ss64.com/${HHS_MY_SHELL}/%CMD%.html"

  if [[ $# -ne 1 ]]; then
    echo "Usage: __hhs ${FUNCNAME[0]} <bash_command>"
  else
    cmd="${1}"
    url="${ss63_url//%CMD%/$cmd}"
    echo -e "${ORANGE}Opening SS64 man page for ${1}: ${url}"
    sleep 2
    __hhs_open "${url}" && quit 0 ''
    quit 1 "Failed to open url \"${url}\" !"
  fi

  quit 0
}

# @purpose: Clear HomeSetup logs, backups and caches and restore original HomeSetup files.
function reset() {

  local all_files title mchoose_file ret_val=0

  all_files=(
    "${HHS_LOG_DIR}/*.log"
    "${HHS_BACKUP_DIR}/*.bak"
    "${HHS_CACHE_DIR}/*.cache"
    "${HOME}/.inputrc"
    "${HHS_DIR}/.aliasdef"
    "${HHS_SETUP_FILE}"
    "${HHS_SHOPTS_FILE}"
  )

  __hhs_has 'colorls' && gem which colorls &>/dev/null && all_files+=("$(dirname "$(gem which colorls)")/yaml/*.yaml")
  __hhs_has 'starship' && all_files+=("${STARSHIP_CONFIG}")

  title="${YELLOW}Attention! Mark what you want to delete  (${#all_files[@]})${NC}"
  mchoose_file=$(mktemp)
  if __hhs_mchoose "${mchoose_file}" "${title}" "${all_files[@]}"; then
    [[ $(wc -c < "$mchoose_file") -le 1 ]] && return 1
    clear
    echo ' ' >> "${mchoose_file}"
    echo -e "${YELLOW}Deleting selected files...${NC}\n"
    while read -r -d ' ' file; do
      echo -en "${HHS_HIGHLIGHT_COLOR}Deleting file ${WHITE}"
      echo -n "${file} $(printf '\056%.0s' {1..60})" | head -c 60
      # shellcheck disable=SC2086
      if \rm -f ${file} &> /dev/null; then
        echo -e "${WHITE}${GREEN} OK${NC}"
      else
        echo -e "${WHITE}${RED} FAILED${NC}"
        ret_val=1
      fi
    done < "${mchoose_file}"
    echo ''
  fi
  [[ -f "${mchoose_file}" ]] && \rm -f "${mchoose_file}" &> /dev/null
  source "${HOME}/.bash_prompt"
  echo -e "${YELLOW}Some changes will take effect after you 'reopen' your terminal!${NC}"

  return $ret_val
}
