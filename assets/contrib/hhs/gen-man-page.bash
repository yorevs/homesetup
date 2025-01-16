#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: gen-man-page.bash
# Purpose: Generate a manual for a Shell Script.
# Created: Sep 11, 2012
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team


# Current Version
VERSION="1.0.0"

# Help message to be displayed by the script.
USAGE="
    Manual Generator for Shell Scripts.

    usage: $(basename "$0") [OPTION <ARGS>]

    Options:

        -h, --help      : Show this help message.
        -f, --manfile   : Indicate the '.man' file to be used for the
                          manual generation. If not specified, the default
                          is to use the same name of the script + '.man'.
"

RED="\033[31m"
GREEN="\033[32m"
NC="\033[m"

TODAY=$(date +'%m-%d-%Y')

SCRIPT="${SCRIPT:-MyScript}"

MAN_FILE="${SCRIPT//\.*/}"

MAN_DIR="${TEMP:-/tmp}/${MAN_FILE}.1"

MAN_DATA="
01 .\" ${TITLE:-Manual title}
02 .\" ${CONTACT_INFO:-Contact information}
03 .TH man 8 ${TODAY} ${VERSION} ${SCRIPT} Manual
04 .SH NAME
05 ${SCRIPT} \- ${PURPOSE:-Script purpose}
06 .SH SYNOPSIS
07 ${SCRIPT} ${SYNOPSIS:-Synopsis here}
08 .SH DESCRIPTION
09 ${DESCRIPTION:-Description here}
10 .SH OPTIONS
11 ${OPTIONS:-Script options}
12 .SH SEE ALSO
13 ${SEE_ALSO:-See also section}
14 .SH TODO
15 ${TODOS:-Todo section}
16 .SH AUTHOR
17 ${AUTHOR_INFO:-Author information}
"

# Check program options.
while test -n "$1"
do

  # Execute the requested action.
  case "$1" in

    -h | --help)
      echo "$USAGE"
      exit 0
    ;;
    -f | --manfile)
      [[ -z "$2" ]] && { echo "${RED}Man file must be specified!${NC}"; exit 1; }
      MAN_FILE="$2"
      shift
    ;;

    *)
      echo "${RED}Invalid option: \"$1\" !${NC}"
      exit 1
    ;;

  esac
  shift

done

mkdir -p "${MAN_DIR}"

while IFS= read -r line; do
  [[ $line =~ ^[0-9]+\ + ]] && { echo "${line#?? }"; continue; }
done <<< "${MAN_DATA}" > "${MAN_DIR}/${MAN_FILE}"

echo "${GREEN}Man page created at at: ${MAN_DIR}/${MAN_FILE}${NC}"
man "${MAN_DIR}/${MAN_FILE}"

echo ''
