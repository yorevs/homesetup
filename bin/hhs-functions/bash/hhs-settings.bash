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
  
  local version envs_file ret_val
  
  version="$(python3 -m setman -v | tr -d '\n')"
  
  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} [-h] [-v] [-s] [-p] operation <args> ..."
      echo " ____       _"
      echo "/ ___|  ___| |_ _ __ ___   __ _ _ __"
      echo "\___ \ / _ \ __| '_ \` _ \ / _\` | '_\ "
      echo " ___) |  __/ |_| | | | | | (_| | | | |"
      echo "|____/ \___|\__|_| |_| |_|\__,_|_| |_|"
      echo ""
      echo "HsPyLib Settings Manager ${version//setman /}- Manage your terminal settings."
      echo ""
      echo "    Options:"
      echo "      -h, --help               show this help message and exit"
      echo "      -v, --version            show program's version number and exit"
      echo "      -s, --simple             display without formatting."
      echo "      -p, --preserve           whether to preserve (no overwrite) existing settings."
      echo ""
      echo "    Arguments:"
      echo "        operation : the operation to execute. One of "
      echo "                    {get,set,del,list,search,truncate,import,export,source}"
      echo "            get       : Retrieve the specified setting."
      echo "            set       : Upsert the specified setting."
      echo "            del       : Delete the specified setting."
      echo "            list      : List in a table all settings matching criteria."
      echo "            search    : Search and display all settings matching criteria."
      echo "            truncate  : Clear all settings matching name."
      echo "            import    : Import settings from a CSV formatted file."
      echo "            export    : Export settings to a CSV formatted file."
      echo "            source    : Source (bash export) all environment settings to current shell."
      echo "}"
    return 1
  fi
  
  if [[ " ${*} " =~ " source " ]]; then
    envs_file=$(mktemp)
    python3 -m setman source > "${envs_file}"
    ret_val=$?
  else
    python3 -m setman "${@}"
    ret_val=$?
  fi
  
  [[ -n "${envs_file}" && -f "${envs_file}" ]] && source "${envs_file}"
  [[ -n "${envs_file}" && -f "${envs_file}" ]] && \rm -f "${envs_file}"
  
  return ${ret_val}
}
