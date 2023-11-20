#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains all HHS-App built-in functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# @purpose: List all HHS App Plug-ins and Functions.
# @param $1 [opt] : Instead of a formatted as a list, flat the commands for bash completion.
function list() {

  local args=("${@}")

  if [[ "$1" == "help" ]]; then
    echo "Usage: __hhs ${FUNCNAME[0]} [-flat] [-plugins] [-funcs]" && quit 0
  elif [[ "${args[*]}" =~ -flat ]]; then
    args=("${args[@]/'-flat'/}")
    [[ ${#args[@]} -eq 1 || "${args[*]}" =~ -plugins ]] &&
      for next in "${PLUGINS[@]}"; do echo -n "${next} "; done
    [[ ${#args[@]} -eq 1 || "${args[*]}" =~ -funcs ]] &&
      for next in "${HHS_APP_FUNCTIONS[@]}"; do echo -n "${next} "; done
    echo ''
    quit 0
  else
    echo ''
    echo "${YELLOW}HomeSetup application command list"
    if [[ ${#args[@]} -eq 0 || "${args[*]}" =~ -plugins ]]; then
      echo ''
      echo "${ORANGE}-=- HHS Plugins -=-"
      echo ''
      for idx in "${!PLUGINS[@]}"; do
        printf "${WHITE}%.2d. " "$((idx + 1))"
        echo -e "Plug-In :: ${HHS_HIGHLIGHT_COLOR}\"${PLUGINS[$idx]}\"${NC}"
      done
    fi
    if [[ ${#args[@]} -eq 0 || "${args[*]}" =~ -funcs ]]; then
      echo ''
      echo "${ORANGE}-=- HHS Functions -=-"
      echo ''
      for idx in "${!HHS_APP_FUNCTIONS[@]}"; do
        printf "${WHITE}%.2d. " "$((idx + 1))"
        echo -e "Function :: ${HHS_HIGHLIGHT_COLOR}\"${HHS_APP_FUNCTIONS[$idx]}\"${NC}"
      done
    fi
  fi

  echo ''
  quit 0
}

# @purpose: Search for all __hhs_functions describing it's containing file name and line number.
function funcs() {

  local idx columns fn_name cache_file usage filters count matches=0

  usage="Usage: ${FUNCNAME[0]} [regex_filters]"

  [[ "$1" == 'help' ]] && echo "${usage}" && quit 0

  cache_file="${HHS_CACHE_DIR}/hhs-funcs-${HHS_VERSION//./}.cache"

  filters="$*"
  filters=${filters// /\|}
  [[ -z "${filters}" ]] && filters=".*"

  echo ' '
  echo "${YELLOW}-=- Available HomeSetup v${HHS_VERSION} functions matching [ ${filters} ] -=-"
  echo ' '

  if [[ ! -s "${cache_file}" ]]; then
    search_hhs_functions "${HHS_HOME}/bin/hhs-functions/bash" "${HHS_HOME}/dotfiles/bash" "${HHS_HOME}/bin/dev-tools/bash"
    printf "%s\n" "${HHS_FUNCTIONS[@]}" >"${cache_file}"
  else
    IFS=$'\n'
    read -r -d '' -a HHS_FUNCTIONS < <(grep . "${cache_file}")
    IFS="${OLDIFS}"
  fi

  columns="$(tput cols)"
  count="${#HHS_FUNCTIONS[@]}"
  for idx in "${!HHS_FUNCTIONS[@]}"; do
    fn_name="${HHS_FUNCTIONS[${idx}]}"
    if [[ $fn_name =~ $filters ]]; then
      ((matches++))
      printf "${YELLOW}%${#count}d  ${HHS_HIGHLIGHT_COLOR}" "$((matches))"
      echo -en "${fn_name:0:${columns}}${NC}"
      [[ "${#fn_name}" -ge "${columns}" ]] && echo -n "..."
      echo -e "${NC}"
    fi
  done

  [[ $matches -eq 0 ]] && echo -e "${YELLOW}No functions found matching \"${filters}\"${NC}"

  echo ''
  quit 0
}

# @purpose: Retrieve HomeSetup logs.
# @param $1 [opt] : The hhs file to retrieve logs from.
# @param $2 [opt] : The log level to retrieve.
function logs() {

  local level log_level logfile logs

  HHS_LOG_LINES=${HHS_LOG_LINES:-100}
  level=$(echo "${1}" | tr '[:lower:]' '[:upper:]')

  if [[ -n "${level}" ]]; then
    if ! list_contains "DEBUG FINE TRACE INFO OUT WARN WARNING SEVERE CRITICAL FATAL ERROR ALL" "${level}"; then
      logfile="${HHS_LOG_DIR}/${1//.log/}.log"
      if [[ ! -f "${logfile}" ]]; then
        logs=$(find "${HHS_LOG_DIR}" -type f -name '*.log' -exec basename {} \;)
        echo -e "${RED}## Log file not found: ${logfile}."
        echo -e "${ORANGE}\nAvailable log files: \n\n${logs}\n"
        quit 1
      fi
      level=$(echo "${2}" | tr '[:lower:]' '[:upper:]')
      if [[ -n "${level}" ]]; then
        if ! list_contains "DEBUG FINE TRACE INFO OUT WARN WARNING SEVERE CRITICAL FATAL ERROR ALL" "${level}"; then
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
  level=${level:='ALL'}

  [[ "${level}" == "ALL" ]] && log_level='.*'
  [[ "${level}" != "ALL" ]] && log_level="${level}"

  echo ''
  echo -e "${ORANGE}Retrieving logs from ${logfile} (last ${HHS_LOG_LINES} lines) [level='${level}'] :${NC}"
  echo ''
  __hhs_tailor -n "${HHS_LOG_LINES}" "${logfile}" | grep "${log_level}"

  quit 0
}

# @purpose: Fetch the ss64 manual from the web for the specified bash command.
# @param $1 [req] : The bash command to find out the manual.
function man() {

  local ss63_url="https://ss64.com/${HHS_MY_SHELL}/%CMD%.html"

  if [[ $# -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <bash_command>"
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

# @purpose: Open the HomeSetup GitHub project board.
function board() {

  local raw_content_url="${HHS_GITHUB_URL}/projects/1"

  echo "${ORANGE}Opening HomeSetup board from: ${raw_content_url} ${NC}"
  sleep 2
  __hhs_open "${raw_content_url}" && quit 0

  quit 1 "Failed to open url \"${raw_content_url}\" !"
}

# @purpose: Clear HomeSetup logs, backups and caches
function invalidate() {

  local all_files ANS

  all_files=(
    "${HHS_LOG_DIR}/*.log"
    "${HHS_BACKUP_DIR}/*.bak"
    "${HHS_CACHE_DIR}/*.cache"
    "${HOME}/.inputrc"
    "${HHS_DIR}/.aliasdef"
  )
  echo ''
  read -rn 1 -p "${YELLOW}This will remove all log/*, backups/*, cache/*, .aliasdef and ~/.inputrc files. Continue y/[n] ? " ANS
  echo ''
  if [[ "${ANS}" == "y" || "${ANS}" == 'Y' ]]; then
    echo ''
    for f_ext in ${all_files[*]}; do
      echo -n "${BLUE}Removing ${f_ext} ... "
      if \rm -f "${f_ext}"; then
        echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
      else
        echo -e "${WHITE} [ ${RED}FAILED${NC} ]"
      fi
    done
  fi
  echo ''

  return 0
}

# @purpose: Open a docsify version of the HomeSetup README.
function docsify() {

  local docsify_url raw_content_url url

  docsify_url='https://docsify-this.net/?basePath='
  raw_content_url='https://raw.githubusercontent.com/yorevs/homesetup/master&sidebar=true'
  url="${docsify_url}${raw_content_url}"

  __hhs_open "${url}" && quit 0

  quit 1 "Failed to open url \"${url}\" !"
}
