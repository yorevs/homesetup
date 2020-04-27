#!/usr/bin/env bash

#  Script: vault.bash
# Purpose: Wrapper to vault application
# Created: Jan 06, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# Vault python application location
VAULT_DIR="${HHS_HOME}/bin/apps/bash/hhs-app/plugins/vault"

# @purpose: HHS plugin required function
function help() {
  python "${VAULT_DIR}/vault.py" -h
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python "${VAULT_DIR}/vault.py" -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  python "${VAULT_DIR}/vault.py" "${@}"
  exit $?
}
