#!/usr/bin/env bash

#  Script: bash_commons.bash
# Purpose: This file is a set of commonly used functions. Dotfiles sometimes requires the following functions
#          to be available for use. It is sources from the first loaded dotfile.
# Created: Apr 26, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>


# @function: Check if a command is available on the current shell session.
# @param $1 [Req] : The command to check.
function __hhs_has() {
  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  fi
  type "$1" > /dev/null 2>&1
  
  return $?
}

# @function: Log a message to the HomeSetup log file.
# @param $1 [Req] : The log level.
# @param $* [Req] : The log level. One of ["WARN", "DEBUG", "INFO", "ERROR", "ALL"].
function __hhs_log() {
  local level="${1}" message="${2}"
  if [[ $# -lt 2 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <log_level> <log_message>"
    return 1
  fi
  case "${level}" in
    'DEBUG' | 'INFO' | 'WARN' | 'ERROR' | 'ALL')
      printf "%s %5.5s  %s\n" "$(date +'%m-%d-%y %H:%M:%S ')" "${level}" "${message}" >> "${HHS_LOG_FILE}"
      ;;
    *)
      echo "${FUNCNAME[0]}: invalid log level \"${level}\" !" 2>&1
      return 1
      ;;
  esac
  
  return 0
}

# @function: Replacement for the original source bash command.
# @param $1 [Req] : Path to the file to be source'd
function __hhs_source() {

  local filepath="$1"
  
  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <filepath>"
    return 1
  fi
  if [[ ! -f "${filepath}" ]]; then
    __hhs_log "ERROR" "${FUNCNAME[0]}: File \"${filepath}\" not found !"
    return 1
  else
    if ! grep "File \"${filepath}\" was sourced !" "${HHS_LOG_FILE}"; then
      # shellcheck disable=SC1090
      if source "${filepath}" 2>> "${HHS_LOG_FILE}"; then
        __hhs_log "DEBUG" "File \"${filepath}\" was sourced !"
      else
        __hhs_log "ERROR" "File \"${filepath}\" was not sourced !"
      fi
    else
      __hhs_log "WARN" "File \"${filepath}\" was already sourced !"
    fi
  fi
  
  return 0
}

# @function: Check whether an URL is reachable.
# @param $1 [Req] : The URL to test reachability.
function __hhs_is_reachable() {
  if [[ $# -eq 0 || '-h' == "$1" || -z "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <url>"
    return 1
  fi
  
  curl --output /dev/null --silent --connect-timeout 1 --max-time 2 --head --fail "${1}"
  
  return $?
}
