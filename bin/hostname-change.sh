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

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$1" -o "$1" = "" && usage

# Check current hostname
HOSTN=$(hostname)
echo "Current hostname is: \"$HOSTN\""
read -r -p "Enter new hostname (ENTER to cancel): " NEW_HOSTN

if test -n "$NEW_HOSTN" -a "$HOSTN" != "$NEW_HOSTN"; then

    echo "Your new hostname has changed to: \"$NEW_HOSTN\""

    if test "$(uname -s)" = "Darwin"; then
        sudo scutil --set HostName "$NEW_HOSTN"
    else
        # Change the hostname in /etc/hosts & /etc/hostname
        sudo sed -i "s/$HOSTN/$NEW_HOSTN/g" /etc/hosts
        sudo sed -i "s/$HOSTN/$NEW_HOSTN/g" /etc/hostname
        read -r -n 1 -p "Press 'y' key to reboot now: " ANS
        test "$ANS" = "y" -o "$ANS" = "Y" && sudo reboot
    fi
fi

quit 0
