#!/usr/bin/env bash

#  Script: ${app.bash}
# Purpose: ${purpose}
# Created: Mon DD, YYYY
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# shellcheck disable=SC1090
[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && \. "${HHS_DIR}/bin/app-commons.bash"

# Functions to be unset after quit
# shellcheck disable=SC2034
UNSETS+=('main' 'parse_args')

# Current application version
VERSION=0.9.0

# ------------------------------------------
# Basics

# @purpose: Parse command line arguments
parse_args() {

  # If not enough arguments is passed, display usage message
  if [[ ${#} -lt 1 ]]; then
    usage 0
  fi

  # Loop through the command line options.
  # Short opts: -<C>, Long opts: --<Word>
  while [[ ${#} -gt 0 ]]; do
    case "$1" in
    -h | --help)
      usage
      ;;
    -v | --version)
      version
      ;;

    *)
      break
      ;;
    esac
    shift
  done
}

# @purpose: Program entry point
main() {
  parse_args "${@}"
  echo "
  ARG_NUM: ${#}
  ARGUMENTS: ${*}
  "
}

main "${@}"
quit 0
