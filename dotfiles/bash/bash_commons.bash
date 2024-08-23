#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: bash_commons.bash
# Purpose: This file is a set of commonly used functions. Dotfiles sometimes requires the following functions
#          to be available for use. It is sources from the first loaded dotfile.
# Created: Apr 26, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_commons"

# @function: Check if a command is available on the current shell session.
# @param $1 [Req] : The command to check.
function __hhs_has() {

  local cmd="$1"

  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  fi

  type "${cmd}" &>/dev/null

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
    'INFO' | 'WARN' | 'ERROR' | 'ALL')
      printf "%s %5.5s  %s\n" "$(date +'%m-%d-%y %H:%M:%S ')" "${level}" "${message}" >>"${HHS_LOG_FILE}"
      ;;
    'DEBUG')
      [[ "${HHS_VERBOSE_LOGS}" -eq 1 ]] && \
         printf "%s %5.5s  %s\n" "$(date +'%m-%d-%y %H:%M:%S ')" "${level}" "${message}" >>"${HHS_LOG_FILE}"
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
  elif [[ ! -s "${filepath}" ]]; then
    __hhs_log "WARN" "${FUNCNAME[0]}: Skipping \"${filepath}\" because it was not found or empty!"
  else
    if source "${filepath}" >>"${HHS_LOG_FILE}"; then
      __hhs_log "DEBUG" "File \"${filepath}\" was loaded !"
      return 0
    else
      __hhs_log "ERROR" "Failed to load file \"${filepath}\"!"
    fi
  fi

  return 1
}

# shellcheck disable=SC2139
# @function: Check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression
# @param $1 [Req] : The alias to set/check.
# @param $* [Req] : The alias expression.
function __hhs_alias() {

  local all_args alias_expr alias_name

  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <alias_name>='<alias_expr>"
    return 1
  fi

  all_args="${*}"
  alias_expr="${all_args#*=}"
  alias_name="${all_args//=*/}"

  if ! type "$alias_name" >/dev/null 2>&1; then
    if alias "${alias_name}"="${alias_expr}" >/dev/null 2>&1; then
      return 0
    else
      echo "${RED}Failed to alias: \"${alias_name}\" !${NC}" 2>&1
    fi
  else
    __hhs_log "WARN" "Setting alias: \"${alias_name}\" was skipped because it already exists !"
  fi

  return 1
}

# @function: Echo a message in red color into stderr.
# @param $1 [Req] : The message to be echoed.
function __hhs_errcho() {

  if [[ "$#" -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <message>"
    return 1
  else
    echo -e "${RED}error: ${*}${NC}" 1>&2
  fi

  return $?
}

# @function: Check whether an URL is reachable.
# @param $1 [Req] : The URL to test reachability.
function __hhs_is_reachable() {
  if [[ $# -eq 0 || '-h' == "$1" || -z "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <url>"
    return 1
  fi

  \curl --output /dev/null --silent --connect-timeout 1 --max-time 2 --head --fail "${1}"

  return $?
}

# @function: In-place sed.
# @param $1..$N [Req] : Sed parameters.
function ised() {
  case "${HHS_MY_OS}" in
    Darwin)
      sed -i '' -E "${@}"
      ;;
    Linux)
      sed -i'' -r "${@}"
      ;;
  esac

  return $?
}

# @function: Regex sed. Same as sed -r.
# @param $1..$N [Req] : Sed parameters.
function esed() {
  case "${HHS_MY_OS}" in
    Darwin)
      sed -E "${@}"
      ;;
    Linux)
      sed -r "${@}"
      ;;
  esac

  return $?
}

# @purpose: `trim' all leading and trailing whitespaces.
# @param $1..$N [Req] : The text to be trimmed.
function trim() {

  file=${1:-/dev/stdin}
  if [[ "${file}" == '/dev/stdin' ]]; then
    while read -r stream; do
      echo "${stream}" | esed -E 's/^[[:blank:]]*|[[:blank:]]*$//g'
    done <"${file}"
  else
    esed -E 's/^[[:blank:]]*|[[:blank:]]*$//g' "${file}"
  fi

  return 0
}

# @purpose: Check whether the list contains the specified string.
# @param $1 [Req] : The list to check against.
# @param $2 [Req] : The string to be checked.
function list_contains() {
  [[ ${1} =~ (^|[[:space:]])${2}($|[[:space:]]) ]] && return 0
  return 1
}
