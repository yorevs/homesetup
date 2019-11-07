#!/usr/bin/env bash

#  Script: ${app.bash}
# Purpose: ${purpose}
# Created: Mon DD, YYYY
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME [optionals] <mandatories>
"

# Import pre-defined Bash Colors
# shellcheck source=/dev/null
[ -f ~/.bash_colors ] && \. ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR ${RED}
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    unset -f quit usage version main
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

main() {
    usage 1
}

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
while test -n "$1"
do
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
