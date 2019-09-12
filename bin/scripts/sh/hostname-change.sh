#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: hostname-change.sh
# Purpose: Change the hostname permanently
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=1.0.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <new_hostname>
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
[ "$1" = '-h' ] || [ "$1" = '--help' ] || [ -z "$1" ] && usage 0
[ "$1" = '-v' ] || [ "$1" = '--version' ] && version

# Check current hostname
HOSTN=$(hostname)
echo "Current hostname is: \"$HOSTN\""
read -r -p "Enter new hostname (ENTER to cancel): " NEW_HOSTN

if [ -n "$NEW_HOSTN" ] && [ "$HOSTN" != "$NEW_HOSTN" ]; then

    echo "Your new hostname has changed to: \"$NEW_HOSTN\""

    if [ "$(uname -s)" = "Darwin" ]; then
        sudo scutil --set HostName "$NEW_HOSTN"
    else
        # Change the hostname in /etc/hosts & /etc/hostname
        sudo sed -i "s/$HOSTN/$NEW_HOSTN/g" /etc/hosts
        sudo sed -i "s/$HOSTN/$NEW_HOSTN/g" /etc/hostname
        read -r -n 1 -p "Press 'y' key to reboot now: " ANS
        [ "$ANS" = "y" ] || [ "$ANS" = "Y" ] && sudo reboot
    fi
fi

quit 0
