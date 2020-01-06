#!/usr/bin/env bash

#  Script: ${app.bash}
# Purpose: ${purpose}
# Created: Mon DD, YYYY
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# Functions to be unset after quit
# shellcheck disable=SC2034
UNSETS+=('main')

STUFF='is not set'
STUFF_VAL=

main() {
  echo "
  ARG_NUM: ${#}
  ARGUMENTS: ${*}
  STUFF: ${STUFF}
  STUFF_VAL= ${STUFF_VAL}
  "
}

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
POSITIONAL=("$@")
while [[ $# -gt 0 ]]; do
  case "$1" in
  -s | --stuff)
    shift # past argument
    STUFF="is set to ${1}"
    shift # past value
    STUFF_VAL=${1}
  ;;

  *)
    quit 1 "Invalid option: \"$1\""
  ;;
  esac
  shift # move to next argument
done

main "${POSITIONAL[@]}"
