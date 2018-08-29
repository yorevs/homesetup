#!/usr/bin/env bash

#  Script: ${app.sh}
# Purpose: ${purpose}
# Created: Mon DD, YYYY
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME="$(basename $0)"

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
    
    test -n "$2" -o "$2" != "" && echo -e "$2"
    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$1" -o "$1" = "" && usage

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
while test -n "$1"
do
    case "$1" in
        <shor_opt> | <long_opt>)
            shift
            # Do stuff
        ;;
        
        *)
            quit 1 "Invalid option: \"$1\""
        ;;
    esac
    shift
done
