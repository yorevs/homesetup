#!/usr/bin/env bash

#  Script: ${app.name}.bash
# Purpose: ${app.purpose}
# Created: Mon DD, YYYY
#  Author: ${author}
#  Mailto: ${author.mail}

# Current application version
VERSION=0.9.0

# This application name.
APP_NAME="${0##*/}"

# Help message to be displayed by the application.
USAGE=${USAGE:-"
Usage: ${APP_NAME} <arguments> [options]
"}

# @purpose: Exit the application with the provided exit code and exhibits an exit message if provided.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR .
# @param $2 [Opt] : The exit message to be displayed.
quit() {
  # Unset all declared functions.
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
  echo "Executing ${APP_NAME} ..."
  parse_args "${@}"
  echo "
  ARG_NUM: ${#}
  ARGUMENTS: ${*}
  "
}

main "${@}"
quit 0
