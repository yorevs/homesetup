#!/usr/bin/env bash
# shellcheck disable=1090,1091

#  Script: app-commons.bash
# Purpose: Commonly used bash code functions and variables
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current application version.
VERSION=${VERSION:-0.9.0}

# This application name.
APP_NAME="${APP_NAME:-${0##*/}}"

# Help message to be displayed by the application.
USAGE=${USAGE:-"
usage: ${APP_NAME} <arguments> [options]
"}

# Default identifiers to be unset
UNSETS=('quit' 'usage' 'version' 'trim')

# We need to load the dotfiles below due to non-interactive shell.
[[ -s "${HOME}"/.bash_commons ]] && source "${HOME}"/.bash_commons
[[ -s "${HOME}"/.bash_env ]] && source "${HOME}"/.bash_env
[[ -s "${HOME}"/.bash_colors ]] && source "${HOME}"/.bash_colors
[[ -s "${HOME}"/.bash_icons ]] && source "${HOME}"/.bash_icons
[[ -s "${HOME}"/.bash_aliases ]] && source "${HOME}"/.bash_aliases
[[ -s "${HOME}"/.bash_functions ]] && source "${HOME}"/.bash_functions

# Execute a cleanup after the application has exited.
trap _app_cleanups_ EXIT

# @purpose: When the application has exited, execute some cleanups.
function _app_cleanups_() {
  # Unset all declared functions
  unset -f quit usage version trim list_contains toml_get_key
  unset -f "${UNSETS[*]}"
}

# @purpose: Exit the application with the provided exit code and exhibits an exit message if provided.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR .
# @param $2 [Opt] : The exit message to be displayed.
function quit() {

  local exit_code=${1:-0}

  shift
  if [[ ${exit_code} -ne 0 && ${#} -ge 1 ]]; then
    echo -en "${RED}error: ${APP_NAME} => " 1>&2
  fi
  [[ ${#} -eq 0 ]] && echo -e "${NC}"
  [[ ${#} -ge 1 ]] && echo -e "${*} ${NC}" 1>&2

  exit "${exit_code}"
}

# @purpose: Display the usage message and exit with the provided code ( or zero as default ).
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE .
# @param $2 [Opt] : The exit message to be displayed.
function usage() {

  local exit_code=${1:-0}

  shift && echo -en "${USAGE}"
  [[ ${#} -gt 0 ]] && echo ''
  quit "${exit_code}" "$@"
}

# @purpose: Display the current application version and exit.
function version() {
  quit 0 "$APP_NAME v$VERSION"
}

# Check if the user passed the help or version parameters.
[[ "$1" = '-h' || "$1" = '--help' ]] && usage 0
[[ "$1" = '-v' || "$1" = '--version' ]] && version
