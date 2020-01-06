#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: app-commons.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=${VERSION:-0.9.0}

# This script name.
APP_NAME="${0##*/}"

# Help message to be displayed by the script.
USAGE=${USAGE:-"
Usage: ${APP_NAME} <arguments> [options]
"}

# Import pre-defined HomeSetup bash files
[ -f ~/.bash_colors ] && \. ~/.bash_colors
[ -f ~/.bash_aliases ] && \. ~/.bash_aliases
[ -f ~/.bash_functions ] && \. ~/.bash_functions

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR ${RED}
# @param $2 [Opt] : The exit message to be displayed.
quit() {

  unset -f quit usage version trim "${UNSETS[*]}"
  ret=$1
  shift
  [ "$ret" -gt 1 ] && echo -en "${RED}" 1>&2
  [ "$#" -gt 0 ] && echo -en "$*" 1>&2
  # Unset all declared functions
  echo -e "${NC}" 1>&2
  exit "$ret"
}

# Usage message.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE
usage() {
  quit "$1" "$USAGE"
}

# Version message.
version() {
  quit 0 "$VERSION"
}

# Check if the user passed the help or version parameters.
[ "$1" = '-h' ] || [ "$1" = '--help' ] && usage 0
[ "$1" = '-v' ] || [ "$1" = '--version' ] && version

# Trim whitespaces
trim() {

  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"

  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  echo -en "$var"
}