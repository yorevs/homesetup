#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: app-commons.bash
# Purpose: Commonly used bash code functions and variables
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# Current application version.
VERSION=${VERSION:-0.9.0}

# This application name.
APP_NAME="${0##*/}"

# Help message to be displayed by the application.
USAGE=${USAGE:-"
Usage: ${APP_NAME} <arguments> [options]
"}

# Default identifiers to be unset
UNSETS=('quit' 'usage' 'version' 'trim')

# Import pre-defined HomeSetup bash files
[[ -f "${HOME}"/.bash_env ]] && \. "${HOME}"/.bash_env
[[ -f "${HOME}"/.bash_colors ]] && \. "${HOME}"/.bash_colors
[[ -f "${HOME}"/.bash_aliases ]] && \. "${HOME}"/.bash_aliases
[[ -f "${HOME}"/.bash_functions ]] && \. "${HOME}"/.bash_functions

# @purpose: Exit the application with the provided exit code and exhibits an exit message if provided.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR
# @param $2 [Opt] : The exit message to be displayed.
quit() {
  # Unset all declared functions.
  unset -f quit usage version trim "${UNSETS[*]}"
  exit_code=${1:-0}
  shift
  [[ ${exit_code} -ne 0 && ${#} -ge 1 ]] && echo -en "${RED}${APP_NAME}: " 1>&2
  [[ ${#} -ge 1 ]] && echo -e "${*} ${NC}" 1>&2
  [[ ${#} -gt 0 ]] && echo ''
  # shellcheck disable=SC2086
  exit ${exit_code}
}

# @purpose: Display the usage message and exit with the provided code ( or zero as default ).
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE .
# @param $2 [Opt] : The exit message to be displayed.
usage() {
  exit_code=${1:-0}
  shift
  echo -en "${USAGE}"
  [[ ${#} -gt 0 ]] && echo ''
  quit "${exit_code}" "$@"
}

# @purpose: Display the current application version and exit.
version() {
  quit 0 "$APP_NAME v$VERSION"
}

# Check if the user passed the help or version parameters.
[[ "$1" = '-h' || "$1" = '--help' ]] && usage 0
[[ "$1" = '-v' || "$1" = '--version' ]] && version

# @purpose: Trim whitespaces from the provided text.
# @param $1..$N [Req] : The text to be trimmed.
trim() {

  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"

  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  echo -en "$var"
  
  return 0
}
