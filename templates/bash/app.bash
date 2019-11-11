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
UNSETS=( main )

main() {
  usage 1
}

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
while test -n "$1"; do
  case "$1" in
  -s | --stuff)
    shift
    # Do stuff
    ;;

  *)
    quit 2 "Invalid option: \"$1\""
    ;;
  esac
  shift
done

main
