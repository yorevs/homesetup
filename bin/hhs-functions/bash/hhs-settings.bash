#!/usr/bin/env bash

#  Script: hhs-settings.bash
# Created: Jul 18, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# shellcheck disable=SC1090
function __hhs_settings() {
  
  local envs_file ret_val=0
  
  if [[ "${#}" -eq 0 ]]; then
    python3 -m setman -h
    ret_val=1
  elif [[ " ${*} " =~ " source " ]]; then
    envs_file=$(mktemp)
    python3 -m setman source -f "${envs_file}"
    ret_val=$?
  else
    python3 -m setman "${@}"
    ret_val=$?
  fi

  [[ -n "${envs_file}" && -f "${envs_file}" ]] && source "${envs_file}"
  [[ -n "${envs_file}" && -f "${envs_file}" ]] && \rm -f "${envs_file}"
  
  echo -e "${NC}"
  
  return ${ret_val}
}
