#!/usr/bin/env bash

#  Script: toolcheck.sh
# Purpose: Check if the required tool is installed on the system.
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@gmail.com

# Current script version.
VERSION=1.0.0

# This script name.
PROC_NAME="$(basename $0)"

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <tool_name> [exit_on_error 'true/[false]']
"

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    if test -n "$2" -o "$2" != ""; then
        echo -e "$2"
    fi

    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$1" -o "$1" = "" && usage

# Import bash colors
test -f ~/.bash_colors && source ~/.bash_colors

TOOL_NAME="$1"

if test -z "$2" -o "$2" = ""; then
    EXIT_ON_FAIL="false"
else
    EXIT_ON_FAIL="$2"
fi

PAD=$(printf '%0.1s' "."{1..60})
PAD_LEN=20

printf "${ORANGE}($(uname -s))${NC} "
printf "Checking: ${YELLOW}${TOOL_NAME}${NC} "
printf '%*.*s' 0 $((PAD_LEN - ${#1})) "$PAD"

CHECK=$(command -v ${TOOL_NAME})

if test -n "${CHECK}" ; then
    printf "${GREEN}INSTALLED${NC} at ${CHECK}\n"
else
    printf "${RED}NOT INSTALLED${NC}\n"
    if test "$EXIT_ON_FAIL" = "true"; then
        printf "${RED}### Error: Unable to continue without the required tool: \"${TOOL_NAME}\"${NC}\n" >&2
        quit 2
    else
        quit 1
    fi
fi

quit 0