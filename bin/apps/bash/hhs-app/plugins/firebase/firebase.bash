#!/usr/bin/env bash

#  Script: firebase.bash
# Purpose: Manager for HomeSetup Firebase integration
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# @purpose: HHS plugin required function
function help() {
  echo "Usage: hhs firebase execute {setup,upload,download} {db_alias}"
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python3 -m firebase -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  ARGS=(${@})
  fb_args=(${ARGS[@]:2})
  python3 -m firebase "${ARGS[0]}" dotfiles."${ARGS[1]}" "${fb_args[@]}"

  exit $?
}
