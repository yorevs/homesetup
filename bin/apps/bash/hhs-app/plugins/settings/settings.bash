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
  
  local args envs_file ret_val=0 num
  
  args=(${@})
  
  if [[ "${#}" -eq 0 ]]; then
    python3 -m setman -h
  # Hook the setman source command
  elif [[ $1 == 'source' ]]; then
    envs_file="$(mktemp)"
    args=(${args[@]:1})
    python3 -m setman source "${args[@]}" -f "${envs_file}"
    echo -en "${NC}"
  # Execute the setman python app normally
  else
    python3 -m setman "${args[@]}"
    echo -e "${NC}"
  fi
  ret_val=$?
  # Check if envfile is not empty and count the exported settings
  if [[ -n "${envs_file}" && -f "${envs_file}" ]]; then
    num=$(wc -l "${envs_file}" | sed -e 's/^[[:space:]]*\([0-9]*\) \/.*/\1/')
    echo -e "${GREEN}HomeSetup exported (${num}) settings. To export them type:${NC}"
    echo ">> ${BLUE}source ${envs_file}${NC}"
  fi 
  
  quit ${ret_val}
}
