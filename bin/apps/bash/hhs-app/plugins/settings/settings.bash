#!/usr/bin/env bash

#  Script: settings.bash
# Created: Jul 18, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current plugin name
PLUGIN_NAME="settings"

UNSETS=(
  help version cleanup execute
)
  
# @purpose: HHS plugin required function
function help() {
  python3 -m ${PLUGIN_NAME} -h
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python3 -m ${PLUGIN_NAME} -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
  echo -n ''
}

# shellcheck disable=SC1090,SC2206
# @purpose: HHS plugin required function
function execute() {
  
  local args env_file ret_val=0 num
  
  args=(${@})
  
  if [[ "${#}" -eq 0 ]]; then
    python3 -m setman -h
  # Hook the setman source command
  elif [[ $1 == 'source' ]]; then
    env_file="settings-export-$(date +'%Y%m%d%H%M%S')"
    python3 -m setman source "${args[@]:1}" -f "${env_file}"
    echo -en "${NC}"
  # Execute the setman python app normally
  else
    python3 -m setman "${args[@]}"
    echo -e "${NC}"
  fi
  ret_val=$?
  # Check if env_file is not empty and count the exported settings
  if [[ -n "${env_file}" && -f "${env_file}" ]]; then
    num=$(wc -l "${env_file}" | sed -e 's/^[ \t]*\([0-9]*\) *\/*.*/\1/')
    if [[ $num -gt 0 ]]; then
      echo -e "${GREEN}Exported (${num}) settings. To source them type:${NC}"
      echo ">> ${BLUE}source ${env_file}${NC}"
    else
      echo -e "${YELLOW}No settings found!${NC}"
    fi
  fi 
  
  quit ${ret_val}
}