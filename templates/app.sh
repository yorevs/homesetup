#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: ${app.sh}
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

# Import pre-defined .bash_colors
# shellcheck disable=SC1090
test -f ~/.bash_colors && source ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    test "$1" != '0' -a "$1" != '1' && printf "%s" "${RED}"
    test -n "$2" -a "$2" != "" && printf "%s\n" "${2}"
    # Unset all declared functions
    unset -f quit usage version 
    printf "%s\n" "${NC}"
    exit "$1"
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Version message.
version() {
    quit 1 "$VERSION"
}

# Check if the user passed the help or version parameters.
test "$1" = '-h' -o "$1" = '--help' && usage
test "$1" = '-v' -o "$1" = '--version' && version

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
            quit 1 "Invalid option: \"$1\""
        ;;
    esac
    shift
done

usage