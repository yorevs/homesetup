#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: toolcheck.bash
# Purpose: Check if the a tool is installed on the system.
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=1.0.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <tool_name> [exit_on_error 'true/[false]']
"

# Import pre-defined Bash Colors
# shellcheck source=/dev/null
[ -f ~/.bash_colors ] && \. ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR ${RED}
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    unset -f quit usage version 
    ret=$1
    shift
    [ "$ret" -gt 1 ] && printf "%s" "${RED}"
    [ "$#" -gt 0 ] && printf "%s" "$*"
    # Unset all declared functions
    printf "%s\n" "${NC}"
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

TOOL_NAME="$1"

if test -z "$2" -o "$2" = ""; then
    EXIT_ON_FAIL="false"
else
    EXIT_ON_FAIL="$2"
fi

PAD=$(printf '%0.1s' "."{1..60})
PAD_LEN=20

printf '%s\n' "${ORANGE}($(uname -s))${NC} "
printf '%s\n' "Checking: ${YELLOW}${TOOL_NAME}${NC} "
printf '%*.*s' 0 $((PAD_LEN - ${#1})) "$PAD"

CHECK=$(command -v "${TOOL_NAME}")

if [ -n "${CHECK}" ]; then
    printf '%s\n' "${GREEN}INSTALLED${NC} at ${CHECK}\n"
else
    printf '%s\n' "${RED}NOT INSTALLED${NC}\n"
    if [ "$EXIT_ON_FAIL" = "true" ]; then
        printf '%s\n' "${RED}### Error: Unable to continue without the required tool: \"${TOOL_NAME}\"${NC}\n" >&2
        quit 2
    else
        quit 1
    fi
fi

quit 0
