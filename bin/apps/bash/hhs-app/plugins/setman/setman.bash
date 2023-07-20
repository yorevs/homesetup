#!/usr/bin/env bash

#  Script: setman.bash
# Created: Jul 18, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current plugin name
PLUGIN_NAME="setman"

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
  
  local args envs_file ret_val=0 re="source"
  
  args=(${@})
  
  if [[ "${#}" -eq 0 ]]; then
    python3 -m setman -h
  elif [[ ${args[*]//\n/} =~ ${re} ]]; then
    envs_file=$(mktemp)
    python3 -m setman "${args[@]}" -f "${envs_file}"
    echo -en "${NC}"
  else
    python3 -m setman "${args[@]}"
    echo -e "${NC}"
  fi
  ret_val=$?
  
  [[ -n "${envs_file}" && -f "${envs_file}" ]] && source "${envs_file}"
  [[ -n "${envs_file}" && -f "${envs_file}" ]] && \rm -f "${envs_file}"
  
  quit ${ret_val}
}
