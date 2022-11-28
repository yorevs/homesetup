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
  usage 0
}

# @purpose: List all HHS App Plug-ins and Functions
# @param $1 [opt] : Instead of a formatted listing, flat the commands for completion.
function list() {

  if [[ "$1" == "opts" ]]; then
    for next in "${PLUGINS[@]}"; do echo -n "${next} "; done
    for next in "${HHS_APP_FUNCTIONS[@]}"; do echo -n "${next} "; done
    echo ''
    quit 0
  else
    echo ' '
    echo "${YELLOW}HomeSetup Application Manager"
    echo ' '
    echo " ${YELLOW}---- Plugins"
    echo ' '
    for idx in "${!PLUGINS[@]}"; do
      printf "${WHITE}%.2d. " "$((idx + 1))"
      echo -e "Registered plug-in => ${HHS_HIGHLIGHT_COLOR}\"${PLUGINS[$idx]}\"${NC}"
    done

    echo ' '
    echo " ${YELLOW}---- Functions"
    echo ' '
    for idx in "${!HHS_APP_FUNCTIONS[@]}"; do
      printf "${WHITE}%.2d. " "$((idx + 1))"
      echo -e "Registered built-in function => ${HHS_HIGHLIGHT_COLOR}\"${HHS_APP_FUNCTIONS[$idx]}\"${NC}"
    done
  fi

  quit 0 ' '
}

# @purpose: Search for all __hhs_functions describing it's containing file name and line number.
function funcs() {

  register_hhs_functions

  echo "${YELLOW}Available HomeSetup __hhs_Functions"
  echo ' '
  for idx in "${!HHS_FUNCTIONS[@]}"; do
    printf "${WHITE}%.2d. " "$((idx + 1))"
    echo -e "Registered __hhs_<function> => ${HHS_HIGHLIGHT_COLOR}\"${HHS_FUNCTIONS[$idx]}\"${NC}"
  done

  quit 0 ' '
}

# shellcheck disable=2086
# @purpose: Retrieve HomeSetup logs
# @param $1 [opt] : The number of log lines to retrieve.
function logs() {
  n=${1:-100}
  echo ''
  echo -e "${ORANGE}HomeSetup logs (last ${n} lines):${NC}"
  echo ''
  tail -${n} "${HHS_LOGFILE}"
  echo ''
}

# @purpose: Fetch the ss64 manual from the web for the specified bash command.
# @param $1 [req] : The bash command to find out the manual.
function man() {
  
  local ss63_url='https://ss64.com/bash/{}.html'
  
  if [[ $# -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <bash_command>"
  else
    __hhs_open "${ss63_url//\{\}/${1}}"
  fi
}

# @purpose: Open the HomeSetup GitHub project board for the current version.
function board() {

  local repo_url="https://github.com/yorevs/homesetup/projects/1"

  echo "${GREEN}Opening HomeSetup board from: ${repo_url} ${NC}"
  __hhs_open "${repo_url}" && quit 0 ' '

  quit 1 "Failed to open url \"${repo_url}\" !"
}
