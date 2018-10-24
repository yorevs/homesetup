#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: fetch.sh
# Purpose: Fetch data using the REST API
# Created: Oct 24, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@gmail.com
#    Site: https://github.com/yorevs/homesetup

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME [optionals] <mandatories>
"

# Import pre-defined .bash_colors
test -f ~/.bash_colors && source ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    # Unset all declared functions
    unset -f quit usage version 

    test "$1" != '0' -a "$1" != '1' && echo "${RED}"
    test -n "$2" -a "$2" != "" && printf "%s\n" "${2}"
    test "$1" != '0' -a "$1" != '1' && echo "${NC}"
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

usage