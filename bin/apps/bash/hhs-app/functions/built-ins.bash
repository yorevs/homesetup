#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains all HHS-App built-in functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# @purpose: Provide a help for __hhs functions
function help() {
  echo TODO
}

# @purpose: List all HHS App Plug-ins and Functions
# @param $1 [opt] : Instead of a formatted as a list, flat the commands for bash completion.
function list() {

  if [[ "$1" == "opts" ]]; then
    for next in "${PLUGINS[@]}"; do echo -n "${next} "; done
    for next in "${HHS_APP_FUNCTIONS[@]}"; do echo -n "${next} "; done
    echo ''
    quit 0
  else
    echo ''
    echo "${YELLOW}HomeSetup Application Manager"
    echo ''
    echo "${YELLOW}-=- HHS Plugins -=-"
    echo ''
    for idx in "${!PLUGINS[@]}"; do
      printf "${WHITE}%.2d. " "$((idx + 1))"
      echo -e "Plug-In :: ${HHS_HIGHLIGHT_COLOR}\"${PLUGINS[$idx]}\"${NC}"
    done

    echo ''
    echo "${YELLOW}-=- HHS Functions -=-"
    echo ''
    for idx in "${!HHS_APP_FUNCTIONS[@]}"; do
      printf "${WHITE}%.2d. " "$((idx + 1))"
      echo -e "Function :: ${HHS_HIGHLIGHT_COLOR}\"${HHS_APP_FUNCTIONS[$idx]}\"${NC}"
    done
  fi

  quit 0 ' '
}

# @purpose: Search for all __hhs_functions describing it's containing file name and line number.
function funcs() {

  find_hhs_functions

  echo ' '
  echo "${YELLOW}-=- Available HomeSetup functions -=-"
  echo ' '
  for idx in "${!HHS_FUNCTIONS[@]}"; do
    printf "${WHITE}%.2d. ${HHS_HIGHLIGHT_COLOR}" "$((idx + 1))"
    echo -e "HHS-Function :: ${HHS_FUNCTIONS[$idx]}${NC}"
  done

  quit 0 ' '
}

# shellcheck disable=2086
# @purpose: Retrieve HomeSetup logs
# @param $1 [opt] : The log level to retrieve.
function logs() {
  HHS_LOG_LINES=${HHS_LOG_LINES:-100}
  level=$(echo "${1}" | tr '[:lower:]' '[:upper:]')
  
  if [[ -n "${level}" ]]; then
    list_contains "DEBUG INFO WARN ERROR ALL" "${level}" || quit 1 "Invalid log level ${level}"
  fi
  
  [[ "${level}" == "ALL" ]] && level='.*'
  
  echo ''
  echo -e "${ORANGE}HomeSetup logs (last ${HHS_LOG_LINES} lines) matching level ['${level:-ALL}'] :${NC}"
  echo ''
  grep "${level}" -m ${HHS_LOG_LINES} "${HHS_LOG_FILE}" | __hhs_tailor
  echo ''
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
}

# @purpose: Open the HomeSetup GitHub project board.
function board() {

  local repo_url="https://github.com/yorevs/homesetup/projects/1"

  echo "${ORANGE}Opening HomeSetup board from: ${repo_url} ${NC}"
  sleep 2
  __hhs_open "${repo_url}" && quit 0 ''
  quit 1 "Failed to open url \"${repo_url}\" !"
}
