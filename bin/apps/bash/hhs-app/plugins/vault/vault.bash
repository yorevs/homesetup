#!/usr/bin/env bash

#  Script: vault.bash
# Purpose: Wrapper to vault application
# Created: Jan 06, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# @purpose: HHS plugin required function
function help() {
  python3 -m vault -h
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python3 -m vault -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  python3 -m vault "${@}"
  exit $?
}
