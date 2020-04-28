#!/usr/bin/env bash

#  Script: firebase.bash
# Purpose: Manager for HomeSetup Firebase integration
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# Vault python application location
FIREBASE_DIR="${HHS_HOME}/bin/apps/bash/hhs-app/plugins/firebase"

# @purpose: HHS plugin required function
function help() {
  python "${FIREBASE_DIR}/firebase.py" -h
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python "${FIREBASE_DIR}/firebase.py" -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  python "${FIREBASE_DIR}/firebase.py" "${@}"
  exit $?
}
