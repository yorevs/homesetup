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
  
  local envs_file ret_val=0 re="source" args=(${@})
  
  # Update the settings configuration
  echo "hhs.setman.database = ${HHS_SETMAN_DB_FILE}" > "${HHS_SETMAN_CONFIG_FILE}"
  
  if [[ "${#}" -eq 0 ]]; then
    python3 -m setman -h
  elif [[ ${args[*]//\n/} =~ ${re} ]]; then
    envs_file=$(mktemp)
    python3 -m setman "${args[@]}" -f "${envs_file}"
  else
    python3 -m setman "${@}"
  fi
  ret_val=$?

  [[ -n "${envs_file}" && -f "${envs_file}" ]] && source "${envs_file}"
  [[ -n "${envs_file}" && -f "${envs_file}" ]] && \rm -f "${envs_file}"
  
  echo -en "${NC}"
  
  return ${ret_val}
}
