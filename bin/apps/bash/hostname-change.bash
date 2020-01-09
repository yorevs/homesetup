#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2034

#  Script: hostname-change.bash
# Purpose: Change the hostname permanently
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=1.0.0

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME <new_hostname>
"

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# Check current hostname
HOSTN=$(hostname)
NEW_HOSTN="${1}"

echo "Current hostname is: \"$HOSTN\""
[ -z "$NEW_HOSTN" ] && read -r -p "Enter new hostname (ENTER to cancel): " NEW_HOSTN

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
